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


class ViewModel: ObservableObject{
  var songMap: [String:Song] = [String:Song]() // map of song objects
  private let ref = Database.database().reference()
  private let store = Firestore.firestore()
//  var user: UserInfo = UserInfo()
  
  func getPosts(){
    // retrieve posts from database
    // return list of all posts
//    var post: Post = Post()
    // filter posts by friend IDs
    
    store.collection("Posts").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")
            }
        }
    }

    // make one request with a list of song IDs
    // iterate through song ids
    //  put each song into a song object
    //  store map (key: songID, value: song Object)
    
    
  }
}
