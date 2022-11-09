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
  @Published var songIDs:[String] = []
  @Published var user: UserInfo = UserInfo()
  func getSelf() {
    let getMe = Spartan.getMe(success: { (user) in
      print("HERE IS USER: \(user.id as! String)")
      self.username = user.id as! String
    }, failure: { (err) in
      print("err instead: ", err)
      
    })
  }
  func getPosts() {
    let getMe = Spartan.getMe(success: { (user) in
      print("HERE IS USER: \(user.id as! String)")
      self.username = user.id as! String
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
//          post.songID = data["songID"] as! String
//          self.songIDs.append(post.songID)
          post.song = self.getSong(data["songID"] as! String)
          
          post.createdAt = (data["createdAt"] as! Timestamp).dateValue()
          post.likes = data["likes"] as? [String] ?? []
          post.moods = data["moods"] as? [String] ?? []
          self.posts.append(post)
          print("post now: ", post)
        }
      }
    }
  } // END OF GET POST
  
  // creates a song object from a songID
  func getSong(_ songID: String) -> Song {
    var songObj: Song = Song()
    _ = Spartan.getTrack(id: songID, market: .us, success: { (track) in
      songObj.songID = songID
      songObj.songName = track.name
      songObj.spotifyLink = track.href
      songObj.artists = track.artists[0].name
//      songObj.albumURL = track.album.images[0].url ?? "No Artist Found"
      if track.album == nil{
        songObj.albumURL = "no image found"
      } else{
        songObj.albumURL = track.album.images[0].url 
      }
      print("track album ", track.album)
      print("track song ", track.name)
      print("song obj", songObj)

    }, failure: { (error) in
      print("couldn't get song: ", error)
    })
    return songObj
  }
  
  func getAllFeedSongs(){
    print("song ids \(self.songIDs)")
    _ = Spartan.getTracks(ids: self.songIDs, market: .us, success: { (tracks) in
      for obj in tracks{
        print("HERE", obj)
      }
      // Do something with the tracks
    }, failure: { (error) in
      print(error)
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

