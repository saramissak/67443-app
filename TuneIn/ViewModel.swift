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
  @Published var searchedSongs:  [Song] = []

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
    getSelf()
    getPosts()
    self.loggedIn = true

//    loggedIn = true
    
    
  }
  
  
//  var user: UserInfo = UserInfo()
  func getPosts() {
    store.collection("Posts").order(by: "createdAt", descending: true)
      .addSnapshotListener { querySnapshot, error in
        if let error = error {
          print("Error getting posts: \(error.localizedDescription)")
          return
        }
        self.posts = querySnapshot?.documents.compactMap { document in
          try? document.data(as: Post.self)
        } ?? []
        print("print posts", self.posts)
      }
//      print("print posts", self.posts)
  }
  
  func searchSong(_ songName: String) {
    var songs:[Song] = []
    if songName != "" {
      _ = Spartan.search(query: songName, type: .track, success: { (pagingObject: PagingObject<SimplifiedTrack>) in
        for obj in pagingObject.items{
          var currSong = Song()
          currSong.id = obj.id as! String
          currSong.songName = obj.name
          currSong.artist = obj.artists[0].name
          
//          self.getAlbumImage(obj.externalUrls["spotify"])
//          currSong.albumURL = obj.externalUrls
          if obj.previewUrl != nil {
            currSong.previewURL = obj.previewUrl
          }
          songs.append(currSong)
        }
        
        self.searchedSongs = songs
      }, failure: { (error) in
        print(error)
      })
    }
  }
  
  func getAlbumImage(_ albumLink: Optional<String>, completionHandler:@escaping (String)->()) {
    var albumID = ""
    if albumLink != nil {
      if albumLink?.split(separator: "/").last != nil {
        albumID = String(albumLink!.split(separator: "/").last!)
      }
    }
    var albumUrl = ""
    _ = Spartan.getAlbum(id: albumID, market: .us, success: { (album) in
      DispatchQueue.main.async(){
        completionHandler(albumUrl)
      }
    }, failure: { (error) in
      print(error)
    })
  }
  
  func makePost(song: Song, caption: String){
    var newPost = Post()
    let newPostRef = self.store.collection("Posts").document()
    newPost.userID = self.username
    print("here is the username ", self.username)
    newPost.song = song
    newPost.caption = caption
    newPost.createdAt = NSDate() as Date
    newPost.likes = []
    newPost.moods = []
    newPost.id = UUID().uuidString

    do {
      _ = try newPostRef.setData(from: newPost)
    } catch let error {
        print("Error writing city to Firestore: \(error)")
    }
  }
  
  
  // creates a song object from a songID
//  func getSong(_ songID: String, completionHandler:@escaping (Song)->()) {
//    var songObj: Song = Song()
//    _ = Spartan.getTrack(id: songID, market: .us, success: { (track) in
//      songObj.id = songID
//      songObj.songName = track.name
//      songObj.spotifyLink = track.href ?? ""
//      songObj.artist = track.artists[0].name
//      if track.album == nil {
//        songObj.albumURL = ""
//      } else{
//        songObj.albumURL = track.album.images[0].url ?? ""
//      }
//      songObj.previewURL = track.previewUrl ?? ""
//
//      print("song obj", songObj)
//      DispatchQueue.main.async(){
//        completionHandler(songObj)
//      }
//    }, failure: { (error) in
//      print("couldn't get song: ", error)
//    })
//  }
  
  
  
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

