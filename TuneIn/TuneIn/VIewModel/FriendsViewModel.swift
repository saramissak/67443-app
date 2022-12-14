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

  func getUsers(_ searchString: String, completionHandler:@escaping (String)->()) {
    if searchString == "" || searchString.count < 1 {
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
                    
          if self.searchedUsers[user.id] == nil {
            self.searchedUsers[user.id] = user
            DispatchQueue.main.async(){
              completionHandler(user.id)
            }
          }
        }
      }
    }
  } // END OF getUsers
  
  func addFriend(_ userID: String, completionHandler:@escaping (Bool)->()) {
    if self.myUserId == ""{
      let _ = Spartan.getMe(success: { (user) in
        self.myUserId = user.id as? String ?? ""
        self.addFriendInFirestore(userID, completionHandler: completionHandler)
      }, failure: { (err) in
        print("err instead: ", err)
      })
    } else {
      self.addFriendInFirestore(userID, completionHandler: completionHandler)
    }
    self.getFriendRequestFromFireStore(completionHandler: {eventListener in })
  }  // END OF addFriend
  
  func addFriendInFirestore(_ userID:String, completionHandler:@escaping (Bool)->()) {
    let senderUserId = self.myUserId
    let receiverUserId = userID
    
    if self.sentFriendRequest[receiverUserId] != nil {
      return
    }
    do {
      if receiverUserId != "" && senderUserId != "" {
        let friendRequest = FriendRequests(requestSender: senderUserId, requestReceiver: receiverUserId)
        let doc = try self.store.collection("FriendRequest").addDocument(from: friendRequest)
        let dict: [String:Any] = [
          "userID": receiverUserId,
          "otherUser": senderUserId,
          "type": "friend request",
        ]
        let userRef = store.collection("UserInfo").document(receiverUserId)
        userRef.updateData([
          "notifications": FieldValue.arrayUnion([dict])
        ])
        self.sentFriendRequest[receiverUserId] = doc.documentID
        DispatchQueue.main.async(){
          completionHandler(true)
        }
      }
    } catch {
      fatalError("Unable to add friend request: \(error.localizedDescription).")
    }
  } // END OF addFriendInFirestore
  
  func acceptFriend(_ userID: String, completionHandler:@escaping (String)->()) {
    if self.myUserId == "" {
      let _ = Spartan.getMe(success: { (user) in
        self.myUserId = user.id as? String ?? ""
        self.acceptFriendInFireStore(userID, completionHandler: completionHandler)
      }, failure: { (err) in
        print("err instead: ", err)
      })
    } else {
      self.acceptFriendInFireStore(userID, completionHandler: completionHandler)
    }
  } // END OF acceptFriend
  
  func acceptFriendInFireStore(_ userID:String, completionHandler:@escaping (String)->()) {
    let friend1 = self.myUserId
    let friend2 = userID
    
    if friend1 != "" && friend2 != "" {
      do {
        let friends = Friends(friend1: friend1, friend2: friend2)
        _ = try self.store.collection("Friends").addDocument(from: friends)
        self.friends[friend2] = ""
        self.removeFriendRequest(userID, completionHandler: {eventList in })
        
        let dict: [String:Any] = [
          "otherUser": friend2,
          "userID": friend1,
          "type": "friend added",
        ]
        let dict2: [String:Any] = [
          "userID": friend2,
          "otherUser": friend1,
          "type": "friend added",
        ]
        
        let userRef = store.collection("UserInfo").document(friend2)
        userRef.updateData([
          "notifications": FieldValue.arrayUnion([dict2])
        ])
        let userRef2 = store.collection("UserInfo").document(friend1)
        userRef2.updateData([
          "notifications": FieldValue.arrayUnion([dict])
        ])
        
        DispatchQueue.main.async(){
          completionHandler(friend2)
        }
      } catch {
        print("Unable to accept a friend \(error.localizedDescription)")
      }
    }
  } // END OF acceptFriendInFireStore
  
  func removeFriendRequest(_ userID:String, completionHandler:@escaping (Bool)->()) {
    let user = userID
    if user != "" && self.receivedFriendRequest[user] != nil {
      let friendRequestDocId = self.receivedFriendRequest[user]!
      if friendRequestDocId != "" {
        store.collection("FriendRequest").document(friendRequestDocId).delete { error in
          if var hasError = error {
            DispatchQueue.main.async(){
              completionHandler(false)
            }
          }
        }
      }
      self.receivedFriendRequest.removeValue(forKey: user)
      let dict: [String:Any] = [
        "otherUser": user,
        "userID": self.myUserId,
        "type": "friend request",
      ]
      let userRef = store.collection("UserInfo").document(self.myUserId)
      userRef.updateData([
        "notifications": FieldValue.arrayRemove([dict])
      ])
    }
    DispatchQueue.main.async(){
      completionHandler(true)
    }
  } // END OF removeFriendRequest
  
  func getFriendRequests(completionHandler:@escaping (String)->()) {
    if self.myUserId == "" {
      let _ = Spartan.getMe(success: { (user) in
        self.myUserId = user.id as? String ?? ""
        self.getFriendRequestFromFireStore(completionHandler: completionHandler)
      }, failure: { (err) in
        print("err instead: ", err)
      })
    } else {
      self.getFriendRequestFromFireStore(completionHandler: completionHandler)
    }
  } // END OF getFriendRequests
  
  func getFriendRequestFromFireStore(completionHandler:@escaping (String)->()) {
    let _ = self.store.collection("FriendRequest")
      .whereField("requestReceiver", isEqualTo: self.myUserId)
      .getDocuments() { (querySnapshot, err) in
        if let err = err {
          print("Error getting documents fro FriendRequest: \(err)")
        } else {
          for document in querySnapshot!.documents {
            let data = document.data()
            let sender = data["requestSender"] as? String ?? ""
            
            self.receivedFriendRequest[sender] = document.documentID
            DispatchQueue.main.async(){
              completionHandler(sender)
            }
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
            let receiver = data["requestReceiver"] as? String ?? ""

            self.sentFriendRequest[receiver] = document.documentID
            DispatchQueue.main.async(){
              completionHandler(receiver)
            }
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
            self.sentFriendRequest[friend2] = nil
            DispatchQueue.main.async(){
              completionHandler(friend2)
            }
          } else if friend2 == self.myUserId && self.friends[friend1] == nil{
            self.friends[friend1] = document.documentID
            self.sentFriendRequest[friend1] = nil
            DispatchQueue.main.async(){
              completionHandler(friend1)
            }
          }
        }
      }
    }
  } // END OF getFriendsFireStoreCall
  
  func removeFriend(_ userID:String, completionHandler:@escaping (Bool)->()) {
    let friend = userID
    
    if self.friends[friend] != nil && self.friends[friend] != "" {
      store.collection("Friends").document(self.friends[friend]!).delete { error in
        if let error = error {
          DispatchQueue.main.async(){
            completionHandler(false)
          }
        }
      }
    } else {
      let _ = store.collection("Friends")
        .whereField("friend1", in: [friend, self.myUserId])
        .getDocuments() { (querySnapshot, err) in
        if let err = err {
          print("Error getting documents: \(err)")
          DispatchQueue.main.async(){
            completionHandler(false)
          }
        } else {
          for document in querySnapshot!.documents {
            let data = document.data()
            let friend1 = data["friend1"] as? String ?? ""
            
            if friend1 == friend || friend1 == self.myUserId {
              self.store.collection("Friends").document(document.documentID).delete { error in
                if let error = error {
                  print("Unable to remove friend: \(error.localizedDescription)")
                  DispatchQueue.main.async(){
                    completionHandler(false)
                  }
                }
              }
            }
          }
        }
      }
    }
    self.friends.removeValue(forKey: friend)
    if self.myUserId != "" && friend != "" {
      
      let dict: [String:Any] = [
        "otherUser": self.myUserId,
        "userID": friend,
        "type": "friend added",
      ]
      let dict2: [String:Any] = [
        "userID": self.myUserId,
        "otherUser": friend,
        "type": "friend added",
      ]
      
      let userRef = store.collection("UserInfo").document(self.myUserId)
      userRef.updateData([
        "notifications": FieldValue.arrayRemove([dict2])
      ])
      let userRef2 = store.collection("UserInfo").document(friend)
      userRef2.updateData([
        "notifications": FieldValue.arrayRemove([dict])
      ])
      DispatchQueue.main.async(){
        completionHandler(true)
      }
    }
  } // END OF removeFriend
}

