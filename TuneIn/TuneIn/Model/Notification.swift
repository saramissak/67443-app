//
//  Notifications.swift
//  TuneIn
//
//  Created by Sara Missak on 10/14/22.
//

import Foundation

enum NotificationTypes: String, Codable {
   case like = "Like"
   case comment = "Comment"
   case friendRequest = "Friend Request"
}

struct Notification: Codable, Hashable {
  var userID:    String
  var otherUser: String // who liked, commented, or sent the request
  var type:      String

  var postID: String // used for a like
  var commentID: String // used for a comment
  
  init() {
    userID = ""
    otherUser = ""
    type = ""
    commentID = ""
    postID = ""
  }
}
