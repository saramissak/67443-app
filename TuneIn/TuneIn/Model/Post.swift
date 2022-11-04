//
//  Post.swift
//  TuneIn
//
//  Created by Sara Missak on 10/14/22.
//

import Foundation

struct Post: Codable, Identifiable {
  var id:        String
  var userID:    String
  var songID:    String
  var caption:   String
  var createdAt: Date
  var likes:     [String]
  var moods:     [String]
  
  init() {
    id = ""
    userID = ""
    songID = ""
    caption = ""
    createdAt = Date()
    likes = []
    moods = []
  }
}

struct Comment: Codable, Identifiable {
  var id:     UUID
  var postID: UUID
  var userID: UUID
  var text:   String
  var date:   Date
}
