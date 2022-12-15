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
  private let friendsViewModel = FriendsViewModel()
  @Published var posts: [String:Post] = [:]
  @Published var searchedUsers: [String:UserInfo] = [:]
  @Published var friends: [String:UserInfo] = [:]
  @Published var username: String = ""
  @Published var pfp: UIImage = UIImage(imageLiteralResourceName: "John_Smith")
  @Published var postButton: UIImage = UIImage(imageLiteralResourceName: "Post_button")
  @Published var songIDsForPosts:[String] = []
  @Published var user: UserInfo = UserInfo()
  @Published var comments: [Comment] = []
  @Published var users: [String:UserInfo] = [:]
  typealias Completion = (_ success:Bool) -> Void
  @Published var searchedSongs:  [Song] = []
  @Published var spotifyID: String = ""
  @Published var loggedIn: Bool = false
  @Published var notifications: [[String:Any]] = []
  
  func getSelf(completionHandler:@escaping (String)->()) {
    Spartan.getMe(success: { (user) in
      // Do something with the user object
      self.spotifyID = user.id as! String
      self.getUser(searchString: self.spotifyID)
      self.allUsersToDict()
      DispatchQueue.main.async(){
        completionHandler(user.id as! String)
      }
    }, failure: { (err) in
      print("cant find spotify ID in spartn", err)
    })
  }
  
  func getProfilePic() {
    Spartan.getMe(success: { (user) in
      // Do something with the user object
      self.username = user.id as! String
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
      self.getPosts(completionHandler: {_ in })
    })
    self.loggedIn = true
  }
  
  func login(authToken:String, completionHandler:@escaping (String)->()){
    Spartan.authorizationToken = authToken
    getSelf(completionHandler: { (eventList) in
      self.getPosts(completionHandler: {_ in })
      self.loggedIn = true
    })
    DispatchQueue.main.async(){
      completionHandler(self.user.id as String)
    }
  }
  
  func getPosts(completionHandler:@escaping ([String:Post])->()) {
    // get my friends posts
    friendsViewModel.getFriends(completionHandler: { (eventList) in
      self.store.collection("Posts")
        .whereField("userID", isEqualTo: eventList)
        .addSnapshotListener { querySnapshot, error in
          if let error = error {
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
      DispatchQueue.main.async(){
        completionHandler(self.posts as [String:Post])
      }
    }
  }
  
  func hasPostedSongOfDay() -> Bool{
    let date = Date()
    let dateFormatter = DateFormatter()
     
    dateFormatter.dateFormat = "dd.MM.yyyy"
    let currDate = dateFormatter.string(from: date)
    
    var filtered = posts.filter{ (key, value) -> Bool in
        value.userID == self.user.id
    }
    
    filtered = filtered.filter{ (key, value) -> Bool in
        dateFormatter.string(from: value.createdAt) == currDate
    }
    
    return filtered.count > 0

  }
  
  func getLatestUserPostID(userID: String) -> String{
    let keys = posts
      .filter{ (key, value) -> Bool in
        value.userID == userID
      }
      .sorted(by: { $0.value.createdAt < $1.value.createdAt })
      .map { (key, value) -> String in key}

    if (keys.count > 0) {
      return keys.last!
    } else {
      return ""
    }
  }
  
  func getComments(post: Post, completionHandler:@escaping([Comment])->()) {
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
            self.getUserById(comment!.userID, completionHandler: { (eventList) in })
          }
          return comment
        } ?? []
        DispatchQueue.main.async(){
          completionHandler(self.comments as [Comment])
        }
      }
  }
  
  func getCommentByCommentID(_ id: String, completionHandler:@escaping(String)->()){
    store.collection("Comments").whereField("id", isEqualTo: id).getDocuments(){(querySnapshot, err) in
      if let err = err {
        print("Error getting documents: \(err)")
      } else{
        for document in querySnapshot!.documents {
          let data = document.data()
          DispatchQueue.main.async(){
            completionHandler(data["text"] as? String ?? "")
          }
        }
      }
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
          DispatchQueue.main.async(){
            completionHandler(user)
          }
        }
      }
    }
  }
  
  func searchSong(_ songName: String, completionHandler:@escaping ([Song])->() ) {
    var songs:[Song] = []
    if songName != "" {
      _ = Spartan.search(query: songName, type: .track, success: { (pagingObject: PagingObject<SimplifiedTrack>) in
        for obj in pagingObject.items{
          var currSong = Song()
          currSong.id = obj.id as! String
          currSong.songName = obj.name
          currSong.artist = obj.artists[0].name
 
          if obj.externalUrls != nil {
            currSong.spotifyLink = obj.externalUrls!["spotify"] ?? ""
          }
          
          if obj.uri != nil {
            currSong.previewURL = obj.uri
          }
          songs.append(currSong)
        }
        self.searchedSongs = songs
        DispatchQueue.main.async(){
          completionHandler(songs as [Song])
        }
      }, failure: { (error) in
        print(error)
      })

      
    }
  }
  
  func makePost(song: Song, caption: String, moods: [String]){
    var newPost = Post()
    let newPostRef = self.store.collection("Posts").document()
    newPost.userID = self.user.id
    newPost.song = song
    newPost.caption = caption
    newPost.createdAt = NSDate() as Date
    newPost.likes = []
    newPost.moods = moods
    newPost.id = newPostRef.documentID
    
    self.getSongById(song.id, newPost, newPostRef)
  }
  
  // documentation on get track API endpoint: https://developer.spotify.com/documentation/web-api/reference/#/operations/get-track
  func getAlbumURLById(for id: String) async throws-> String{
    var albumURL = ""
      
    let sessionConfiguration = URLSessionConfiguration.default
    sessionConfiguration.httpAdditionalHeaders = [
      "Authorization": "Bearer \(Spartan.authorizationToken!)"
    ]
    
    let session = URLSession(configuration: sessionConfiguration)
    let SpotifyGetTrackURL = URL(string: "https://api.spotify.com/v1/tracks/\(id)")
      
    let (data, _) = try await session.data(for: URLRequest(url: SpotifyGetTrackURL!))
    let json = try? (JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as? [String:AnyObject])
    if let album = json?["album"] as? NSDictionary {
      if let images = album["images"] as? [NSDictionary] {
        if let firstImage = images[0] as? NSDictionary {
          albumURL = firstImage["url"] as? String ?? ""
        }
      }
    }
    return albumURL
  }

  func getSongById(_ id: String, _ newPost: Post, _ newPostRef: DocumentReference) {
    var post = newPost
    let sessionConfiguration = URLSessionConfiguration.default
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
        if let albumURI = album["uri"] as? String {
          post.song.albumURI = albumURI
        }
      }
      if let uri = json["uri"] as? String {
        post.song.previewURL = uri
      }
      
      do {
        try newPostRef.setData(from: post)
      } catch let error {
          print("Error writing city to Firestore: \(error)")
      }
    }
    getTrackTask.resume()
  }
  
  func createDefaultUser(_ spotifyID: String){
    // creates a fake user with stella's spotify ID
    self.user = UserInfo()
      let _ = Spartan.getMe(success: { (user) in
        self.user.username = user.id as! String
        self.user.spotifyID = spotifyID
        self.user.profileImage = user.images![0].url!
        self.user.name = user.displayName ?? ""
        self.user.bio = ""
        self.user.favoriteGenre = ""
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
    let _ = store.collection("UserInfo")
      .whereField("spotifyID", isEqualTo: searchString)
      .getDocuments() { (querySnapshot, err) in
      if let err = err {
        print("Error getting documents: \(err)")
      } else {
        if querySnapshot!.documents.count == 0{
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
            self.user.favoriteGenre = data["favoriteGenre"] as? String ?? ""
          }
        }
      }
    }
  }
  
  func getUsers(_ searchString: String) {
    if searchString == "" || searchString.count < 1 {
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

          self.users[user.id] = user
        }
      }
    }
  }
  
  func getNotifications(){
    self.user.notifications = []
    let _ = store.collection("UserInfo")
      .whereField("spotifyID", isEqualTo: self.spotifyID)
      .getDocuments() { (querySnapshot, err) in
        if let err = err {
          print("Error getting documents: \(err)")
        } else {
          for document in querySnapshot!.documents {
            let data = document.data()
            for notif in data["notifications"] as? [[String:Any]] ?? []{
              var newNotif = Notification()
              newNotif.userID = notif["userID"] as? String ?? ""
              newNotif.postID = notif["postID"] as? String ?? ""
              newNotif.commentID = notif["commentID"] as? String ?? ""
              newNotif.commentID = notif["commentID"] as? String ?? ""
              newNotif.otherUser = notif["otherUser"] as? String ?? ""
              newNotif.type = notif["type"] as? String ?? ""
              self.user.notifications.append(newNotif)
            }
          }
        }
      }
  }
  
  func editAccount(bio: String? = nil,
                   name: String? = nil,
                   username: String? = nil,
                   genre: String? = nil) {
    if bio != nil && bio!.isEmpty != true{
      store.collection("UserInfo").document(user.id).updateData(["bio": bio!])
    }
    if name != nil && name!.isEmpty != true {
      store.collection("UserInfo").document(user.id).updateData(["name": name!])
    }
    if genre != nil && genre!.isEmpty != true {
      store.collection("UserInfo").document(user.id).updateData(["favoriteGenre": genre!])
    }
    if username != nil && username!.isEmpty != true {
      let sameUsernameUserQuery = store.collection("UserInfo")
        .whereField("username", isEqualTo: username!)
      sameUsernameUserQuery.getDocuments() { (querySnapshot, err) in
        if let err = err {
          print("Error getting documents: \(err)")
        } else {
          if querySnapshot!.documents.isEmpty{
            self.store.collection("UserInfo").document(self.user.id).updateData(["username": username!])
          }
        }
      }
    }
  }
  
  func unlikePost(post: Post){
    let postRef = store.collection("Posts").document(post.id)
    postRef.updateData([
      "likes": FieldValue.arrayRemove([user.id])
    ])
    self.getPosts(completionHandler: {_ in })

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
    self.getPosts(completionHandler: {_ in })
  }
  
  func makeCommentNotification(_ comment:Comment? = nil) {
    if comment != nil{
      let comment = comment!
      let notifiedUser = self.posts[comment.postID]?.userID ?? ""
      let dict: [String:Any] = [
        "userID":  notifiedUser,
        "otherUser": comment.userID,
        "type": "comment",
        "commentID": comment.id
      ]
      let userRef = store.collection("UserInfo").document(notifiedUser)
      userRef.updateData([
        "notifications": FieldValue.arrayUnion([dict])
      ])
    }

  }
  
  
  func postComment(docID: String, comment: String, post: Post, completionHandler:@escaping (Comment)->() ) -> Comment? {
    if comment == "" {
      return nil
    }
    
    var newComment = Comment()
    newComment.id = UUID().uuidString
    newComment.date = NSDate() as Date
    newComment.postID = post.id
    newComment.userID = self.user.id
    newComment.text = comment
    
    do {
      _ = try store.collection("Comments").document(newComment.id).setData(from: newComment)
      self.comments.append(newComment)
    } catch let error {
        print("Error writing city to Firestore: \(error)")
    }
    DispatchQueue.main.async(){
      completionHandler(newComment as Comment)
    }
    return newComment
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

