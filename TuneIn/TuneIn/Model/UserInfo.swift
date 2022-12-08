//
//  UserInfo.swift
//  TuneIn
//
//  Created by Sara Missak on 10/14/22.
//

import Foundation

struct UserInfo: Codable, Identifiable {
  var id:               String
  var username:         String
  var name:             String
//  var email:            String
//  var password:         String
  var spotifyID:        String 
  var profileImage:     String // assuming a URL to their image
  var bio:              String
  var favoriteGenre:         String
  var notifications:    [Notification]
  
  init() {
    id = ""
    username = ""
    name = ""
    spotifyID = ""
    profileImage = ""
    bio = ""
    favoriteGenre = ""
    notifications = []
  }
}

struct Friends: Codable {
  var friend1: String
  var friend2: String
}

struct FriendRequests: Codable {
  var requestSender: String
  var requestReceiver: String
}
