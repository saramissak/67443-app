//
//  Song.swift
//  TuneIn
//
//  Created by Sara Missak on 10/14/22.
//

import Foundation

//curl --request GET \
//  --url https://api.spotify.com/v1/albums/id \
//  --header 'Authorization: ' \
//  --header 'Content-Type: application/json'
// information from: https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-album
struct Song: Codable {
  var songId:      String?
  var songName:    String?
  var spotifyLink: ExternalURL?
  var artists:     [Artist]?
  var albumURL:    [AlbumImage]? //picture of the album

  enum CodingKeys : String, CodingKey {
    case songId      = "id"
    case albumURL    = "images"
    case songName    = "name"
    case spotifyLink = "external_urls"
    case artists
  }
}

struct AlbumImage: Codable {
  var url: String
  
  enum CodingKeys : String, CodingKey {
    case url
  }
}

struct ExternalURL: Codable {
  var url: String?
  
  enum CodingKeys : String, CodingKey {
    case url = "spotify"
  }
}

struct Artist: Codable {
  var name: String
  var spotifyLink: ExternalURL? // gets the link to the artist's spotify URL
  
  enum CodingKeys : String, CodingKey {
    case spotifyLink = "external_urls"
    case name
  }
}
