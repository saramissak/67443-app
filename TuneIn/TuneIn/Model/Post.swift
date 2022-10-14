//
//  Post.swift
//  TuneIn
//
//  Created by Sara Missak on 10/14/22.
//

import Foundation

struct Post: Codable, Identifiable {
  var id:        UUID
  var userID:    UUID
  var songID:    String
  var caption:   String
  var createdAt: Date
  var likes:     [UUID]
  var moods:     [String]
}

struct Comment: Codable, Identifiable {
  var id:     UUID
  var postID: UUID
  var userID: UUID
  var text:   String
  var date:   Date
}
