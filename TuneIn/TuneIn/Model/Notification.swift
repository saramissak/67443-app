//
//  Notifications.swift
//  TuneIn
//
//  Created by Sara Missak on 10/14/22.
//

import Foundation

enum NotificationType: String {
   case like = "Like"
   case comment = "Comment"
   case friendRequest = "Friend Request"
}

struct Notification: Codable, Identifiable {
  var id:        UUID
  var userID:    UUID
  var otherUser: UUID // who liked, commented, or sent the request
  var type:      NotificationType
}

struct LikeNotification: Codable { // ask about this
  var notificationID: UUID
  var postID: UUID
}

struct CommentNotification: Codable { // ask about this
  var notificationID: UUID
  var commentID: UUID
}
