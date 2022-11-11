//
//  Post.swift
//  TuneIn
//
//  Created by Sara Missak on 10/14/22.
//

import Foundation

//struct Post: Codable, Identifiable {
//  var id:        String
//  var userID:    String
//  var songID:     String
//  var caption:   String
//  var createdAt: Date
//  var likes:     [String]
//  var moods:     [String]
//
//  init() {
//    id = ""
//    userID = ""
//    songID = ""
//    caption = ""
//    createdAt = Date()
//    likes = []
//    moods = []
//  }
//  init(id: String, userID: String, songID: String, caption: String, createdAt: Date, likes: [String], moods: [String]){
//    self.id = id
//    self.userID = userID
//    self.songID = songID
//    self.songID = songID
//    self.caption = caption
//    self.createdAt = createdAt
//    self.likes = likes
//    self.moods = moods
//  }
struct Post: Codable, Identifiable {
  var id:        String
  var userID:    String
  var song:    Song
  var caption:   String
  var createdAt: Date
  var likes:     [String]
  var moods:     [String]
  
  init() {
    id = ""
    userID = ""
    song = Song()
    caption = ""
    createdAt = Date()
    likes = []
    moods = []
  }
  
}

struct Comment: Codable, Identifiable {
  var id:     String
  var postID: String
  var userID: String
  var text:   String
  var date:   Date
  
  init() {
    id = ""
    userID = ""
    date = Date()
    postID = ""
    text = ""
  }
}
