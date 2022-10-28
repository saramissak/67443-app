//
//  UserInfo.swift
//  TuneIn-Firebase
//
//  Created by The Family on 10/26/22.
//

import Foundation
import FirebaseFirestoreSwift


struct UserInfo: Codable, Identifiable {
  @DocumentID var id: String?
  var username:         String
  var name:             String
  var spotifyID:        String
  var profileImage:     String // assuming a URL to their image
}

struct Friends: Codable {
  var friend1: UUID
  var friend2: UUID
}

struct FriendRequests {
  var requestSender: UUID
  var requestReceiver: UUID
}
