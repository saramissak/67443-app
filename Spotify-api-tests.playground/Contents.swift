import UIKit
import Foundation

// here are the structs we are using in our app
struct Song: Codable {
  var songId:      String?
  var songName:    String?
  var spotifyLink: ExternalURL?
  var artists:     [Artist]?
  var albumURL:    AlbumImage? //picture of the album
  var previewUrl: String?

  enum CodingKeys : String, CodingKey {
    case songId      = "id"
    case albumURL    = "album"
    case songName    = "name"
    case spotifyLink = "external_urls"
    case artists
    case previewUrl  = "preview_url"
  }
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

// to get bearer token: https://developer.spotify.com/console/get-search-item/?q=stitches&type=track&market=&limit=&offset=&include_external=
let bearerToken = ""

var sessionConfiguration = URLSessionConfiguration.default
sessionConfiguration.httpAdditionalHeaders = [
    "Authorization": "Bearer \(bearerToken)"
]

let session = URLSession(configuration: sessionConfiguration)

// the search endpoint for the API
// developer console: https://developer.spotify.com/console/get-search-item/
// API documentation: https://developer.spotify.com/documentation/web-api/reference/#/operations/search
let songToSearchFor = "stitches"
let SpotifySearchURL = URL(string: "https://api.spotify.com/v1/search?q=\(songToSearchFor)&type=track")!
var SpotifySearchRequest = URLRequest(url: SpotifySearchURL)
// gets and parses the data for a search
var callable = session
    .dataTaskPublisher(for: SpotifySearchRequest)
    .sink(receiveCompletion: { completion in
        switch completion {
        case let .failure(reason):
            print(reason)
        case .finished:
            print("")
        }
    }) { receivedValue in
        let decoder  = JSONDecoder()
        let resultString = String(data: receivedValue.data, encoding: .utf8) ?? "Unknown"
        let jsonData = Data(resultString.utf8)
      
        do {
          var searchResponse = try decoder.decode(SearchResponse.self, from: jsonData)
          print(searchResponse)
        } catch {
          print(String(describing: error))
        }
    }

// gets and parses the data for getting a track
// developer console: https://developer.spotify.com/console/get-track/
// documentation: https://developer.spotify.com/documentation/web-api/reference/#/operations/get-track
let id = "5jsw9uXEGuKyJzs0boZ1bT"
let SpotifyGetTrackURL = URL(string: "https://api.spotify.com/v1/tracks/\(id)")!
var SpotifyGetTrackRequest = URLRequest(url: SpotifyGetTrackURL)
// gets and parses the data for a search
var callable2 = session
    .dataTaskPublisher(for: SpotifyGetTrackRequest)
    .sink(receiveCompletion: { completion in
        switch completion {
        case let .failure(reason):
            print(reason)
        case .finished:
            print("")
        }
    }) { receivedValue in
        let decoder  = JSONDecoder()
        let resultString = String(data: receivedValue.data, encoding: .utf8) ?? "Unknown"
        let jsonData = Data(resultString.utf8)
      
        do {
          var song = try decoder.decode(Song.self, from: jsonData)
          print(song)
        } catch {
          print(String(describing: error))
        }
    }
