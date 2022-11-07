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

class ViewModel: ObservableObject{
  var songMap: [String:Song] = [String:Song]() // map of song objects
  private let ref = Database.database().reference()
  private let store = Firestore.firestore()
  @Published var posts: [Post] = []
  @Published var searchedUsers: [String:UserInfo] = [:]
  @Published var friends: [String:UserInfo] = [:]
  
//  var user: UserInfo = UserInfo()
  func getPosts() {
    let getMe = Spartan.getMe(success: { (user) in
      print("HERE IS USER: \(user.id as! String)")
    }, failure: { (err) in
      print("err instead: ", err)
      
    })
    _ = Spartan.getTrack(id: "1V2ZooMGQNlBoHPIvNxAik", market: .us, success: { (track) in
      print("HERE IS SONG: \(track)")
      // Do something with the track
    }, failure: { (error) in
      print(error)
    })
    
    let _ = store.collection("Posts").getDocuments() { (querySnapshot, err) in
      if let err = err {
        print("Error getting documents: \(err)")
      } else {
        for document in querySnapshot!.documents {
          let data = document.data()
          var post: Post = Post()
          post.id = document.documentID
          post.caption = data["caption"] as! String
          post.userID = data["userID"] as! String
          post.songID = data["songID"] as! String
          post.createdAt = (data["createdAt"] as! Timestamp).dateValue()
          post.likes = data["likes"] as? [String] ?? []
          post.moods = data["moods"] as? [String] ?? []
          self.posts.append(post)
          //          print("HERE IS A NEW POST \(post)")
        }
      }
    }
  }
  
  func getUsers(_ searchString: String) {
    if searchString == "" || searchString.count < 1 {
      print("not doing request since search string is just \(searchString)")
      return
    }
    let _ = store.collection("UserInfo")
      .whereField("username", isGreaterThanOrEqualTo: searchString)
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
          
          print("user.username from db request: \(user.username)")
          
          if self.searchedUsers[user.username] == nil {
            self.searchedUsers[user.username] = user
          }
         
        }
      }
    }
  }
  
  func getFriends(_ searchString: String) {
    // want to query firestore and filter by friends list
    // .whereField("username", arrayContainsAny: ["west_coast", "east_coast"])
  }
  
  func getNotifications() {
    let _ = store.collection("Notifications").getDocuments() { (querySnapshot, err) in
      if let err = err {
        print("Error getting documents: \(err)")
      } else {
        for document in querySnapshot!.documents {
          var data = document.data()
          
          if data["type"] != nil {
            switch data["type"] as? String ?? "" {
            case "Like":
              break
            case "Comment":
              break
            case "Friend Request":
              break
            default:
              print("Notification has been ignored with data \(data)")
            }
          }
        }
      }
    }
  }

}

