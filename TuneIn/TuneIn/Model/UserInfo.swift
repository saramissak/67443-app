//
//  UserInfo.swift
//  TuneIn
//
//  Created by Sara Missak on 10/14/22.
//

import Foundation

struct UserInfo: Codable, Identifiable {
  var id:               UUID
  var username:         String
  var name:             String
//  var email:            String
//  var password:         String
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
