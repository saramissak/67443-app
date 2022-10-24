import UIKit
import Foundation

struct Song: Codable {
  var songId:      String?
  var songName:    String?
  var spotifyLink: ExternalURL?
  var artists:     [Artist]?
  var albumURL:    [AlbumImage]? //picture of the album
  var previewUrl: String?

  enum CodingKeys : String, CodingKey {
    case songId      = "id"
    case albumURL    = "images"
    case songName    = "name"
    case spotifyLink = "external_urls"
    case artists
    case previewUrl  = "prevview_url"
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

//https://developer.spotify.com/documentation/web-api/reference/#/operations/search
struct SearchResponse: Codable {
//  var tracks: Track?
}

struct Track: Codable {
  var items: [Song]? // I think will work unsure about alumn image though
  var next: String?
}

// to get bearer token: https://developer.spotify.com/console/get-search-item/?q=stitches&type=track&market=&limit=&offset=&include_external=
let bearerToken = ""

let SpotifyURL = URL(string: "https://api.spotify.com/v1/search?q=stitches&type=track")!
var SpotifyRequest = URLRequest(url: SpotifyURL)

var sessionConfiguration = URLSessionConfiguration.default // 5

sessionConfiguration.httpAdditionalHeaders = [
    "Authorization": "Bearer \(bearerToken)" // 6
]

let session = URLSession(configuration: sessionConfiguration)

let cancellable = session
    .dataTaskPublisher(for: SpotifyRequest) //5
    .sink(receiveCompletion: { completion in
        switch completion {
        case let .failure(reason):
            print(reason)
        case .finished:
            print("")
        }
    }) { receivedValue in
//        print( //6
//            String(data: receivedValue.data, encoding: .utf8) ?? "Unknown"
//        )
        let decoder  = JSONDecoder()
        let resultString = String(data: receivedValue.data, encoding: .utf8) ?? "Unknown"
//      print(resultString)
        let jsonData = Data(resultString.utf8)
      
        do {
          let people = try decoder.decode([SearchResponse].self, from: jsonData)
            print(people)
        } catch {
            print(error)
        }
    }
