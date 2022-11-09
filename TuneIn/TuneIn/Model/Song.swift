//
//  Song.swift
//  TuneIn
//
//  Created by Sara Missak on 10/14/22.
//

import Foundation
import Spartan

// API for getting a track: https://developer.spotify.com/documentation/web-api/reference/#/operations/get-track
struct Song: Codable, Identifiable {
  var id:      String
  var songName:    String
  var spotifyLink: String
  var artist:     String
//  var albumURL:    AlbumImage? //picture of the album
  var albumURL:    String //picture of the album
  var previewURL: String

  init(){
    id = ""
    songName = ""
    spotifyLink = ""
    artist = ""
    albumURL = ""
    previewURL = ""
  }
//  enum CodingKeys : String, CodingKey {
//    case songID      = "id"
//    case albumURL    = "album"
//    case songName    = "name"
//    case spotifyLink = "external_urls"
//    case artists
//    case previewUrl  = "preview_url"
//  }
}

struct AlbumImage: Codable {
  var images: [Images]?
  
  enum CodingKeys : String, CodingKey {
    case images
  }
}

struct Images: Codable {
  var url: String?
  
  enum CodingKeys: String, CodingKey {
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
  var name: String?
  var spotifyLink: ExternalURL? // gets the link to the artist's spotify URL
  
  enum CodingKeys : String, CodingKey {
    case spotifyLink = "external_urls"
    case name
  }
}

// https://developer.spotify.com/documentation/web-api/reference/#/operations/search
struct SearchResponse: Codable {
  var tracks: Track?
}

struct Track: Codable {
  var items: [Song]?
  var next: String?
}

