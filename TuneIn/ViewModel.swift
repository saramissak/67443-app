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
//    print("PRINTING POSTS ON LINE 45 \(self.posts)")

//    Task {
//      await getPostsAsync()
//    }
//  }
//
//  func getPostsAsync() async {
//    // retrieve posts from database
//    // return list of all posts
//    // filter posts by friend IDs
//
//
//    let posts = Task {
//      let _ = store.collection("Posts").getDocuments() { (querySnapshot, err) in
//        if let err = err {
//          print("Error getting documents: \(err)")
//        } else {
//          for document in querySnapshot!.documents {
//            let data = document.data()
//            var post: Post = Post()
//            post.id = document.documentID
//            post.caption = data["caption"] as! String
//            post.userID = data["userID"] as! String
//            post.songID = data["songID"] as! String
//            post.createdAt = (data["createdAt"] as! Timestamp).dateValue()
//            post.likes = data["likes"] as? [String] ?? []
//            post.moods = data["moods"] as? [String] ?? []
//            self.posts.append(post)
//            print("HERE IS A NEW POST \(post)")
//          }
//        }
//      }
//      return self.posts
//    }
//
//    do {
//      self.posts = try await posts.result.get()
//      print("i hate this with a passion")
//    } catch {
//      self.posts = []
//    }
//
//    print("PRINTING POSTS ON LINE 45 \(self.posts)")
//
//    // make one request with a list of song IDs
//    // iterate through song ids
//    //  put each song into a song object
//    //  store map (key: songID, value: song Object)
//

  } // END OF GET POST
  func hexStringToUIColor (hex:String) -> Color {
      var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

      if (cString.hasPrefix("#")) {
          cString.remove(at: cString.startIndex)
      }

      if ((cString.count) != 6) {
          return Color.gray
      }

      var rgbValue:UInt64 = 0
      Scanner(string: cString).scanHexInt64(&rgbValue)

      return Color(
          red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
          green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
          blue: CGFloat(rgbValue & 0x0000FF) / 255.0
      )
  }
//  func getPosts() {
//      store.collection("Posts")
//        .addSnapshotListener { querySnapshot, error in
//          if let error = error {
//            print("Error getting posts: \(error.localizedDescription)")
//            return
//          }
//
//          self.posts = querySnapshot?.documents.compactMap { document in
//            var x = try? document.data(as: Post.self)
//            print("POST \(x)")
//            return x
//          } ?? []
//          print("BRUH \(self.posts)")
//        }
//    print("AYO \(self.posts)")
//    }
}

