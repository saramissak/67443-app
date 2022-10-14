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
  var email:            String
  var password:         String
  var profileImage:     String // assuming a URL to their image
  var sentRequests:     [UUID]
  var listOfFriends:    [UUID]
  var receivedRequests: [UUID]
}
