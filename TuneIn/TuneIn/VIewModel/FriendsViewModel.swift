//
//  ViewModel.swift
//  TuneIn
//
//  Created by The Family on 11/3/22.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseDatabase
import FirebaseFirestoreSwift
import Spartan
import SwiftUI

class FriendsViewModel: ObservableObject{
  var songMap: [String:Song] = [String:Song]() // map of song objects
  private let ref = Database.database().reference()
  private let store = Firestore.firestore()
  @Published var searchedUsers: [String:UserInfo] = [:]
  @Published var friends: [String:String] = [:]
  @Published var receivedFriendRequest: [String:String] = [:]
  @Published var sentFriendRequest: [String:String] = [:]
  var myUserId : String = ""

  func getUsers(_ searchString: String) {
    if searchString == "" || searchString.count < 1 {
      print("not doing request since search string is just \(searchString)")
      return
    }
    let _ = store.collection("UserInfo")
      .getDocuments() { (querySnapshot, err) in
      if let err = err {
        print("Error getting documents: \(err)")
      } else {
        for document in querySnapshot!.documents {
          let data = document.data()
          
          var user = UserInfo()
          user.id = document.documentID
          user.name = data["Name"] as? String ?? ""
          user.profileImage = data["profileImage"] as? String ?? ""
          user.username = data["username"] as? String ?? ""
          user.spotifyID = data["spotifyID"] as? String ?? ""
                    
          if self.searchedUsers[user.username] == nil {
            self.searchedUsers[user.username] = user
          }
        }
      }
    }
  } // END OF getUsers
  
  func addFriend(_ username: String) {
    if self.myUserId == ""{
      let _ = Spartan.getMe(success: { (user) in
        self.myUserId = user.id as? String ?? ""
        self.addFriendInFirestore(username)
      }, failure: { (err) in
        print("err instead: ", err)
      })
    } else {
      self.addFriendInFirestore(username)
    }
    self.getFriendRequestFromFireStore()
  }  // END OF addFriend
  
  func addFriendInFirestore(_ username:String) {
    let senderUserId = self.myUserId
    let receiverUserObj = self.searchedUsers[username] ?? UserInfo()
    let receiverUserId = receiverUserObj.spotifyID
    
    if self.sentFriendRequest[receiverUserId] != nil {
      return
    }
    do {
      if receiverUserId != "" && senderUserId != "" {
        let friendRequest = FriendRequests(requestSender: senderUserId, requestReceiver: receiverUserId)
        let doc = try self.store.collection("FriendRequest").addDocument(from: friendRequest)
        self.sentFriendRequest[receiverUserId] = doc.documentID
      }
    } catch {
      fatalError("Unable to add friend request: \(error.localizedDescription).")
    }
  } // END OF addFriendInFirestore
  
  func acceptFriend(_ username: String) {
    if self.myUserId == "" {
      let _ = Spartan.getMe(success: { (user) in
        self.myUserId = user.id as? String ?? ""
        self.acceptFriendInFireStore(username)
      }, failure: { (err) in
        print("err instead: ", err)
      })
    } else {
      self.acceptFriendInFireStore(username)
    }
  } // END OF acceptFriend
  
  func acceptFriendInFireStore(_ username:String) {
    let friend1 = self.myUserId
    let friend2UserObj = self.searchedUsers[username]!
    let friend2 = friend2UserObj.spotifyID
    
    if friend1 != "" && friend2 != "" {
      do {
        let friends = Friends(friend1: friend1, friend2: friend2)
        _ = try self.store.collection("Friends").addDocument(from: friends)
        self.friends[friend2] = ""
        self.removeFriendRequest(username)
      } catch {
        print("Unable to accept a friend \(error.localizedDescription)")
      }
    }
//    self.removeFriendRequest(username)
  } // END OF acceptFriendInFireStore
  
  func removeFriendRequest(_ username:String) {
    let friend2UserObj = self.searchedUsers[username]!
    let user = friend2UserObj.spotifyID
    
    if user != "" {
      let friendRequestDocId = self.receivedFriendRequest[user]!
      if friendRequestDocId != "" {
        store.collection("FriendRequest").document(friendRequestDocId).delete { error in
          if let error = error {
            print("Unable to remove friendRequets: \(error.localizedDescription)")
          }
        }
      }
    }
    self.receivedFriendRequest.removeValue(forKey: user)
  } // END OF removeFriendRequest
  
  func getFriendRequests() {
    if self.myUserId == "" {
      let _ = Spartan.getMe(success: { (user) in
        self.myUserId = user.id as? String ?? ""
        self.getFriendRequestFromFireStore()
      }, failure: { (err) in
        print("err instead: ", err)
      })
    } else {
      self.getFriendRequestFromFireStore()
    }
  } // END OF getFriendRequests
  
  func getFriendRequestFromFireStore() {
    let _ = self.store.collection("FriendRequest")
      .whereField("requestReceiver", isEqualTo: self.myUserId)
      .getDocuments() { (querySnapshot, err) in
        if let err = err {
          print("Error getting documents fro FriendRequest: \(err)")
        } else {
          for document in querySnapshot!.documents {
            let data = document.data()
            let sender = data["requestSender"] as? String ?? ""
//            let receiver = data["requestReceiver"] as? String ?? ""
            
            self.receivedFriendRequest[sender] = document.documentID
          }
        }
      }
    let _ = self.store.collection("FriendRequest")
      .whereField("requestSender", isEqualTo: self.myUserId)
      .getDocuments() { (querySnapshot, err) in
        if let err = err {
          print("Error getting documents from FriendRequest: \(err)")
        } else {
          for document in querySnapshot!.documents {
            let data = document.data()
//            let sender = data["requestSender"] as? String ?? ""
            let receiver = data["requestReceiver"] as? String ?? ""
            

            self.sentFriendRequest[receiver] = document.documentID
          }
        }
      }
  } // END OF getFriendRequestFromFireStore
  
  
  func getFriends(completionHandler:@escaping (String)->()) -> [String:String] {
    if self.myUserId == ""{
      let _ = Spartan.getMe(success: { (user) in
        self.myUserId = user.id as? String ?? ""
        self.getFriendsFireStoreCall(completionHandler: completionHandler)
      }, failure: { (err) in
        print("err instead: ", err)
      })
    } else {
      self.getFriendsFireStoreCall(completionHandler: completionHandler)
    }
    return self.friends
  } // END OF getFriends
  
  func getFriendsFireStoreCall(completionHandler:@escaping (String)->()) {
    let _ = store.collection("Friends").getDocuments() { (querySnapshot, err) in
      if let err = err {
        print("Error getting documents: \(err)")
      } else {
        for document in querySnapshot!.documents {
          let data = document.data()
          let friend1 = data["friend1"] as? String ?? ""
          let friend2 = data["friend2"] as? String ?? ""
          
          if friend1 == self.myUserId && self.friends[friend2] == nil {
            self.friends[friend2] = document.documentID
            DispatchQueue.main.async(){
              completionHandler(friend2)
            }
          } else if friend2 == self.myUserId && self.friends[friend1] == nil{
            self.friends[friend1] = document.documentID
            DispatchQueue.main.async(){
              completionHandler(friend1)
            }
          }
          
        }
        print("your friends are: ", self.friends)
      }
    }
  } // END OF getFriendsFireStoreCall
  
  func removeFriend(_ username:String) {
    let friendUserObj = self.searchedUsers[username]!
    let friend = friendUserObj.spotifyID
    
    if self.friends[friend] != "" {
      store.collection("Friends").document(self.friends[friend]!).delete { error in
        if let error = error {
          print("Unable to remove friendRequets: \(error.localizedDescription)")
        }
      }
    } else {
      let _ = store.collection("Friends")
        .whereField("requestSender", in: [friend, self.myUserId])
        .whereField("requestReceiver", in: [friend, self.myUserId])
        .getDocuments() { (querySnapshot, err) in
        if let err = err {
          print("Error getting documents: \(err)")
        } else {
          for document in querySnapshot!.documents {
            let data = document.data()
            self.store.collection("Friends").document(document.documentID).delete { error in
              if let error = error {
                print("Unable to remove friendRequets: \(error.localizedDescription)")
              }
            }
          }
        }
      }
    }
    self.friends.removeValue(forKey: friend)
  } // END OF removeFriend
}

