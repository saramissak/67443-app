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
  @Published var searchedUsers: [String:UserInfo] = [:]
  @Published var friends: [String:UserInfo] = [:]
  @Published var username: String = ""
  @Published var songIDsForPosts:[String] = []
  @Published var user: UserInfo = UserInfo()
  typealias Completion = (_ success:Bool) -> Void

  func getSelf() {
    let getMe = Spartan.getMe(success: { (user) in
      print("HERE IS USER: \(user.id as! String)")
      self.username = user.id as! String
    }, failure: { (err) in
      print("err instead: ", err)
      
    })
  }
  
  
  @Published var loggedIn: Bool = false

  
  func login(){
    getPosts()
    self.loggedIn = true

//    loggedIn = true
    
    
  }
  
  
//  var user: UserInfo = UserInfo()
  func getPosts() {

      let _ =  store.collection("Posts").getDocuments() { (querySnapshot, err) in
        if let err = err {
          print("Error getting documents: \(err)")
        } else {
            
            for document in querySnapshot!.documents {
                let data = document.data()
                var post: Post = Post()
                post.id = document.documentID
                post.caption = data["caption"] as! String
                post.userID = data["userID"] as! String
                //              post.songID = data["songID"] as! String
                //              self.songIDsForPosts.append(post.songID)
                //            post.song = await getSong(data["songID"] as! String)
                self.getSong(data["songID"] as! String, completionHandler:{song -> Void in
                  post.song = song
                  print("GOT THE SONG",post.song)
                  post.createdAt = (data["createdAt"] as! Timestamp).dateValue()
                  post.likes = data["likes"] as? [String] ?? []
                  post.moods = data["moods"] as? [String] ?? []
                  self.posts.append(post)
                  print("post now: ", post)
//                  completionHandler()
                })


          }
        }
      }
      
//      print("SONGS IDS: ", songIDsForPosts)

  }
    
  
  // creates a song object from a songID
  func getSong(_ songID: String, completionHandler:@escaping (Song)->()) {
    var songObj: Song = Song()
    
    
    _ = Spartan.getTrack(id: songID, market: .us, success: { (track) in
//      print(track)
      songObj.songID = songID
      songObj.songName = track.name
      songObj.spotifyLink = track.href ?? ""
      songObj.artist = track.artists[0].name
      if track.album == nil {
        songObj.albumURL = ""
      } else{
        songObj.albumURL = track.album.images[0].url ?? ""
      }
      songObj.previewURL = track.previewUrl ?? ""

      print("song obj", songObj)
      DispatchQueue.main.async(){
        completionHandler(songObj)
      }
    }, failure: { (error) in
      print("couldn't get song: ", error)
    })
  }
  
  
  
  func getUser(searchString: String) -> UserInfo {
    print("Search String: \(searchString)")
    if searchString == "" {
      print("[ALERT] not doing request since search string is just \(searchString)")
    }
    let _ = store.collection("UserInfo")
      .whereField("username", isEqualTo: searchString)
      .getDocuments() { (querySnapshot, err) in
      if let err = err {
        print("Error getting documents: \(err)")
      } else {
        for document in querySnapshot!.documents {
          let data = document.data()

          self.user.id = document.documentID
          self.user.name = data["name"] as? String ?? ""
          self.user.profileImage = data["profileImage"] as? String ?? ""
          self.user.username = data["username"] as? String ?? ""
          self.user.spotifyID = data["spotifyID"] as? String ?? ""
          
          print("user.username from db request: \(self.user.username)")
        }
      }
    }
    return self.user
  }
  
  func getUsers(_ searchString: String) {
    if searchString == "" || searchString.count < 1 {
      print("[ALERT] not doing request since search string is just \(searchString)")
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
          let data = document.data()
          
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
}

