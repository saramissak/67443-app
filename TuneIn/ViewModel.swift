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
  @Published var posts: [String:Post] = [:]
  @Published var searchedUsers: [String:UserInfo] = [:]
  @Published var friends: [String:UserInfo] = [:]
  @Published var username: String = ""
  @Published var songIDsForPosts:[String] = []
  @Published var user: UserInfo = UserInfo()
  typealias Completion = (_ success:Bool) -> Void
  @Published var searchedSongs:  [Song] = []
  @Published var spotifyID: String = ""
  @Published var userExisting = false

  func getSelf() {
    
    let getMe = Spartan.getMe(success: { (user) in
          // Do something with the user object
        self.spotifyID = user.id as! String
        self.user = self.getUser(searchString: self.spotifyID)
    }, failure: { (err) in
      print("cant find spotify ID in spartn", err)
      
    })
  }
  
  
  @Published var loggedIn: Bool = false

  
  func login(){
    getSelf()
    getPosts()
    self.loggedIn = true
  }
  
  
//  var user: UserInfo = UserInfo()
  func getPosts() {
    store.collection("Posts").order(by: "createdAt", descending: true)
      .addSnapshotListener { querySnapshot, error in
        if let error = error {
          print("Error getting posts: \(error.localizedDescription)")
          return
        }
        
        self.posts = querySnapshot?.documents.reduce(into: [String: Post]()) { (dict, document) in
          var key = ""
          key = document.documentID
          dict[key] = try? document.data(as: Post.self)
//          print(dict[key]!.likes)
        } ?? [:] as! [String : Post]
      }
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
          
          if obj.previewUrl != nil {
            currSong.previewURL = obj.previewUrl
          }
          print("got the album image \(currSong.albumURL)")
          songs.append(currSong)
        }
        
        self.searchedSongs = songs
      }, failure: { (error) in
        print(error)
      })
    }
  }
  
  func makePost(song: Song, caption: String){
    var newPost = Post()
    let newPostRef = self.store.collection("Posts").document()
    newPost.userID = self.user.username
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
  
//  func createUser(_ id:String) -> UserInfo{
//    var user = makeDefaultUser(id)
//    let newUserRef = self.store.collection("UserInfo").document()
//
//    do {
//      _ = try newUserRef.setData(from: user)
//    } catch let error {
//        print("Error writing user to Firestore: \(error)")
//    }
//    return user
//  }
//
  func createDefaultUser(_ spotifyID: String) -> UserInfo{
    // creates a fake user with stella's spotify ID
    var newUser = UserInfo()
      let _ = Spartan.getMe(success: { (user) in
        newUser.username = user.id as! String
        newUser.spotifyID = spotifyID
        newUser.profileImage = ""
        newUser.name = user.displayName ?? ""
        newUser.bio = ""
        
        let newUserRef = self.store.collection("UserInfo").document()
        do {
          _ = try newUserRef.setData(from: newUser)
        } catch let error {
          print("Error writing city to Firestore: \(error)")
        }
      }, failure: { (err) in
        print("err instead of getting user: ", err)
        
      })
  
  return newUser
}
  
  
  func getUser(searchString: String) -> UserInfo {
    print("Search String: \(searchString)")
    if searchString == "" {
      print("[ALERT] not doing request since search string is just \(searchString)")
//      createUser(searchString)
    }
    let _ = store.collection("UserInfo")
      .whereField("spotifyID", isEqualTo: searchString)
      .getDocuments() { (querySnapshot, err) in
      if let err = err {
        print("Error getting documents: \(err)")
      } else {
        if querySnapshot!.documents.count == 0{
          print("CREATING NEW USER")
          self.user = self.createDefaultUser(searchString)
        } else{
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
  
  func setBio(_ bio: String) {
    store.collection("UserInfo").document(user.id).setData([
        "bio": bio
    ]) { err in
        if let err = err {
            print("Error writing document: \(err)")
        } else {
            print("Document successfully written!")
        }
    }
  }
  
  func likePost(_ id:String, _ likes: [String]) {
    var mutableLikes = likes
    print(likes)
    mutableLikes.append(user.id)
    var postInfo = self.posts[id]!
    postInfo.likes = mutableLikes
    
    do {
      _ = try store.collection("Posts").document(id).setData(from: postInfo)
      print("updated document \(id)")
    } catch let error {
        print("Error writing city to Firestore: \(error)")
    }
//    try store.collection("Posts").document(id).setData(from: postInfo) { err in
//        if let err = err {
//            print("Error writing document: \(err)")
//        } else {
//            print("Document successfully written!")
//        }
//    }
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

