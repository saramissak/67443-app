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

}

