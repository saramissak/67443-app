//
//  Post.swift
//  TuneIn
//
//  Created by Sara Missak on 10/14/22.
//

import Foundation

struct Post: Codable, Identifiable {
  var id:        String
  var userID:     String
  var song:     Song
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
