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

struct Notification: Codable {
  var userID:    String
  var otherUser: String // who liked, commented, or sent the request
//  var type:      NotificationTypes
  var type:      String

  var postID: String // used for a like
  var commentID: String // used for a comment
  
  init() {
    userID = ""
    otherUser = ""
//    type = NotificationTypes.like
    type = ""
    commentID = ""
    postID = ""
  }
}

//protocol LikeNotificationProtocol: NotificationProtocol, Codable {
//  var postID: UUID { get set }
//}

//protocol CommentNotificationProtocol: NotificationProtocol, Codable {
//  var commentID: UUID { get set }
//}
//
//struct LikeNotification: LikeNotificationProtocol, Codable {
//  var postID: UUID
//  var id: UUID
//  var userID: UUID
//  var otherUser: UUID
//  var type: NotificationTypes = NotificationTypes.like
//}
//
//struct CommentNotification: CommentNotificationProtocol, Codable {
//  var id: UUID
//  var userID: UUID
//  var otherUser: UUID
//  var commentID: UUID
//  var type: NotificationTypes = NotificationTypes.comment
//}
//
//struct FriendRequestNotification: NotificationProtocol, Codable {
//  var id: UUID
//  var userID: UUID
//  var otherUser: UUID
//  var type: NotificationTypes = NotificationTypes.friendRequest
//}
