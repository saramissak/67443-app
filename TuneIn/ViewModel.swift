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
//import XCTest

class ViewModel: ObservableObject{
  var songMap: [String:Song] = [String:Song]() // map of song objects
  private let ref = Database.database().reference()
  private let store = Firestore.firestore()
  private let friendsViewModel = FriendsViewModel()
  @Published var posts: [String:Post] = [:]
  @Published var searchedUsers: [String:UserInfo] = [:]
  @Published var friends: [String:UserInfo] = [:]
  @Published var username: String = ""
  @Published var pfp: UIImage = UIImage(imageLiteralResourceName: "John_Smith")
  @Published var songIDsForPosts:[String] = []
  @Published var user: UserInfo = UserInfo()
  @Published var comments: [Comment] = []
  @Published var users: [String:UserInfo] = [:]
  typealias Completion = (_ success:Bool) -> Void
  @Published var searchedSongs:  [Song] = []
  @Published var spotifyID: String = ""
  @Published var loggedIn: Bool = false

  func getSelf(completionHandler:@escaping (String)->()) {
    let getMe = Spartan.getMe(success: { (user) in
      // Do something with the user object
      self.spotifyID = user.id as! String
      self.getUser(searchString: self.spotifyID)
      self.allUsersToDict()
      print(self.users)
      DispatchQueue.main.async(){
        completionHandler(user.id as! String)
      }
    }, failure: { (err) in
      print("cant find spotify ID in spartn", err)
      
    })
  }
  
  func getProfilePic() {
    let getMe = Spartan.getMe(success: { (user) in
      // Do something with the user object
      self.username = user.id as! String
      print("user!!!!! \(user)")
      let pfp = user.images![0].url!
      
      let url = URL(string: pfp)
      let data = try? Data(contentsOf:url!)
      if let imageData = data {
        self.pfp = UIImage(data: imageData)!
      }
      }, failure: { (error) in
          print(error)
      })
  }
  
  func login(){
    getSelf(completionHandler: { (eventList) in
      self.getPosts()
    })
    self.loggedIn = true
    print("USER NOWW:", self.user)
  }
  
  func getPosts() {
    // get my friends posts
    friendsViewModel.getFriends(completionHandler: { (eventList) in
      self.store.collection("Posts")
        .whereField("userID", isEqualTo: eventList)
        .addSnapshotListener { querySnapshot, error in
          if let error = error {
            print("Error getting posts: \(error.localizedDescription)")
            return
          }
          
          let friendsPosts = querySnapshot?.documents.reduce(into: [String: Post]()) { (dict, document) in
            var key = ""
            key = document.documentID
            dict[key] = try? document.data(as: Post.self)
          } ?? [:] as! [String : Post]
          
          self.posts.merge(friendsPosts) {(_, new)  in new}
        }
    })
    
    // get my own posts
    print("my spotify id is:", self.spotifyID)
    self.store.collection("Posts")
    .whereField("userID", isEqualTo: self.spotifyID)
    .addSnapshotListener { querySnapshot, error in
      if let error = error {
        print("Error getting posts: \(error.localizedDescription)")
        return
      }
      
      let friendsPosts = querySnapshot?.documents.reduce(into: [String: Post]()) { (dict, document) in
        var key = ""
        key = document.documentID
        dict[key] = try? document.data(as: Post.self)
      } ?? [:] as! [String : Post]
      
      self.posts.merge(friendsPosts) {(_, new)  in new}
    }
  }
  
  func hasPostedSongOfDay() -> Bool{
    let date = Date()
    let dateFormatter = DateFormatter()
     
    dateFormatter.dateFormat = "dd.MM.yyyy"
    let currDate = dateFormatter.string(from: date)
    print(currDate)
    
    var filtered = posts
      .filter{ (key, value) -> Bool in
        //[TO CHANGE] If this is changed to ID would something happen? Do we want the userID for post to be the username
        value.userID == self.user.username
      }
    
    filtered = filtered.filter{ (key, value) -> Bool in
        dateFormatter.string(from: value.createdAt) == currDate
    }
    print("filtered: \(filtered)")
    
    return filtered.count > 0

  }
  
  func getLatestUserPostID(userID: String) -> String{
    let keys = posts
      .filter{ (key, value) -> Bool in
        value.userID == userID
      }
      .map { (key, value) -> String in key}
    print("keys: \(keys)")
    if (keys.count > 0) {
      return keys[0]
    } else {
      return ""
    }
  }
  
  func getComments(post: Post) {
    self.comments = []
    store.collection("Comments").whereField("postID", isEqualTo: post.id)
      .order(by: "date")
      .addSnapshotListener { querySnapshot, error in
        if let error = error {
          print("Error getting posts: \(error.localizedDescription)")
          return
        }
        self.comments = querySnapshot?.documents.compactMap { document in
          let comment = try? document.data(as: Comment.self)
          if self.users[comment!.userID] == nil {
            self.getUserById(comment!.userID, completionHandler: { (eventList) in
              print("completion handler is done")
            })
          }
          return comment
        } ?? []
        print("here are some commetns", self.comments)
      }
  }
  
  func getUserById(_ id:String, completionHandler:@escaping (UserInfo)->()) {
    let _ = store.collection("UserInfo")
      .whereField("id", isEqualTo: id)
      .getDocuments() { (querySnapshot, err) in
      if let err = err {
        print("Error getting documents: \(err)")
      } else {
        for document in querySnapshot!.documents {
          let data = document.data()
          var user = UserInfo()

          user.id = document.documentID
          user.name = data["name"] as? String ?? ""
          user.profileImage = data["profileImage"] as? String ?? ""
          user.username = data["username"] as? String ?? ""
          user.spotifyID = data["spotifyID"] as? String ?? ""
          
          self.users[user.id] = user
          print("in view model on line 113 the user id is: ", user.id)
          DispatchQueue.main.async(){
            completionHandler(user)
          }
        }
      }
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
          songs.append(currSong)
        }
        
        self.searchedSongs = songs
      }, failure: { (error) in
        print(error)
      })
    }
  }
  
  func makePost(song: Song, caption: String, moods: [String]){
    var newPost = Post()
    let newPostRef = self.store.collection("Posts").document()
    newPost.userID = self.user.id
    print("here is the username ", self.user.username)
    newPost.song = song
    newPost.caption = caption
    newPost.createdAt = NSDate() as Date
    newPost.likes = []
    newPost.moods = moods
    newPost.id = newPostRef.documentID
    
    print("calling getsong by id")
    self.getSongById(song.id, newPost, newPostRef)
    print("finished calling getsong by id")
  }
  
  // documentation on get track API endpoint: https://developer.spotify.com/documentation/web-api/reference/#/operations/get-track
  
  func getAlbumURLById(for id: String) async throws-> String{
    var albumURL = ""
      
    var sessionConfiguration = URLSessionConfiguration.default
    sessionConfiguration.httpAdditionalHeaders = [
      "Authorization": "Bearer \(Spartan.authorizationToken!)"
    ]
    
    let session = URLSession(configuration: sessionConfiguration)
    let SpotifyGetTrackURL = URL(string: "https://api.spotify.com/v1/tracks/\(id)")
      
    let (data, response) = try await session.data(for: URLRequest(url: SpotifyGetTrackURL!))
    let json = try? (JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? [String:AnyObject])
    print("data: ", data)
    print("json: ", json)
    if let album = json?["album"] as? NSDictionary {
      if let images = album["images"] as? [NSDictionary] {
        if let firstImage = images[0] as? NSDictionary {
          albumURL = firstImage["url"] as? String ?? ""
        }
      }
    }
    
      print("album url now ", albumURL)
      return albumURL
    
  }
  
  func getSongById(_ id: String, _ newPost: Post, _ newPostRef: DocumentReference) {
    var post = newPost
    var sessionConfiguration = URLSessionConfiguration.default
    sessionConfiguration.httpAdditionalHeaders = [
      "Authorization": "Bearer \(Spartan.authorizationToken!)"
    ]
    
    let session = URLSession(configuration: sessionConfiguration)
    let SpotifyGetTrackURL = "https://api.spotify.com/v1/tracks/\(id)"
    
    let getTrackTask = session.dataTask(with: URL(string: SpotifyGetTrackURL)!) { (data, response, error) in
      guard let data = data else {
        print("Error: No data to decode")
        return
      }
      
      guard let json = try? JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! [String:AnyObject] else {
        print("Error: Couldn't decode data into a result")
        return
      }
          
      if let album = json["album"] as? NSDictionary {
        if let images = album["images"] as? [NSDictionary] {
          if let firstImage = images[0] as? NSDictionary {
            post.song.albumURL = firstImage["url"] as? String ?? ""
          }
        }
      }
      
      // Output if everything is working right
      print("\(post.song.albumURL)")
      
      do {
        _ = try newPostRef.setData(from: post)
      } catch let error {
          print("Error writing city to Firestore: \(error)")
      }
    }
    
    getTrackTask.resume()
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
  func createDefaultUser(_ spotifyID: String){
    // creates a fake user with stella's spotify ID
    self.user = UserInfo()
      let _ = Spartan.getMe(success: { (user) in
        self.user.username = user.id as! String
        self.user.spotifyID = spotifyID
        self.user.profileImage = user.images![0].url!
        self.user.name = user.displayName ?? ""
        self.user.bio = ""
        self.user.notifications = []
        
        let newUserRef = self.store.collection("UserInfo").document(spotifyID)
        self.user.id = newUserRef.documentID
        do {
          _ = try newUserRef.setData(from: self.user)
          
        } catch let error {
          print("Error writing city to Firestore: \(error)")
        }
      }, failure: { (err) in
        print("err instead of getting user: ", err)
        
      })
}
  
  
  func getUser(searchString: String){
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
          self.createDefaultUser(searchString)
        }
        else{
          for document in querySnapshot!.documents {
            let data = document.data()
            self.user.id = document.documentID
            self.user.name = data["name"] as? String ?? ""
            self.user.profileImage = data["profileImage"] as? String ?? ""
            self.user.username = data["username"] as? String ?? ""
            self.user.spotifyID = data["spotifyID"] as? String ?? ""
            self.user.bio = data["bio"] as? String ?? ""
            print("user.username from db request: \(self.user.username)")
          }

        }

      }
    }
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
          self.users[user.id] = user
          if self.searchedUsers[user.username] == nil {
            self.searchedUsers[user.username] = user
          }
         
        }
      }
    }
  }
  
  func allUsersToDict() {
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

          //[TO CHANGE] is user.username being used as an ID?
          self.users[user.username] = user
          print("just put in user", self.users[user.id])
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
  
  func editAccount(bio: String? = nil, name: String? = nil, username: String? = nil) {
    print("HERE:  " + user.id)
    if bio != nil {
      store.collection("UserInfo").document(user.id).updateData(["bio": bio!])
    }
    if name != nil {
      store.collection("UserInfo").document(user.id).updateData(["name": name!])
    }
    if username != nil {
      store.collection("UserInfo").document(user.id).updateData(["username": username!])
    }
     
  }
  
  func unlikePost(post: Post){
    let postRef = store.collection("Posts").document(post.id)
    postRef.updateData([
      "likes": FieldValue.arrayRemove([user.id])
    ])
    getPosts()
    
    // remove like from notification
    let dict: [String:Any] = [
      "userID":  post.userID,
      "otherUser": user.id,
      "type": "like",
      "postID": post.id
    ]
    let userRef = store.collection("UserInfo").document(post.userID)
    userRef.updateData([
      "notifications": FieldValue.arrayRemove([dict])
    ])
  }
  
  func likePost(_ post:Post) {
    let postRef = store.collection("Posts").document(post.id)
    postRef.updateData([
      "likes": FieldValue.arrayUnion([user.id])
    ])

    let dict: [String:Any] = [
      "userID":  post.userID,
      "otherUser": user.id,
      "type": "like",
      "postID": post.id
    ]
    let userRef = store.collection("UserInfo").document(post.userID)
    userRef.updateData([
      "notifications": FieldValue.arrayUnion([dict])
    ])
    getPosts()
  }
  
  func postComment(docID: String, comment: String, post: Post) {
    if comment == "" {
      return
    }
    
    var newComment = Comment()
    newComment.id = UUID().uuidString
    newComment.date = NSDate() as Date
    newComment.postID = post.id
    newComment.userID = self.user.id
    newComment.text = comment
    
    do {
      _ = try store.collection("Comments").document(newComment.id).setData(from: newComment)
      print("updated document \(docID)")
      self.comments.append(newComment)
    } catch let error {
        print("Error writing city to Firestore: \(error)")
    }
  }
  
  
  func addMoodToPost( moodInput: String, postID: String){
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
  
//  func updateUserName(withUid: String, toNewName: String) {
//      self.db.collection("users").document(withUid).setData( ["name": toNewName], merge: true)
//  }
  
}

