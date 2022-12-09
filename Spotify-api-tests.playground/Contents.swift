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
let bearerToken = "BQBIuJJHujcCkpLWBU3SIcbAwlx-t3SR0TCc13LkKC18lKEnjeXYNWHkr5s2lyGwaEOszLHoNGVIbNAJ1iHK1aHUOPjzs_SCpZyP03LyNwPy8pTuk_5LQJ5EjMfvMwFmqLXKXWxFiCPPRXi1A__31mBZa5-yxgOunVYAT96VIsOt-TPYXrqEI1AK2U9lJrJHjIE"

func createSession() -> URLSession {
  var sessionConfiguration = URLSessionConfiguration.default
  sessionConfiguration.httpAdditionalHeaders = [
      "Authorization": "Bearer \(bearerToken)"
  ]

  return URLSession(configuration: sessionConfiguration)
}

// the search endpoint for the API, This will be for when a user wants to search for a song when creating a new post
// developer console: https://developer.spotify.com/console/get-search-item/
// documentation on search API endpoint: https://developer.spotify.com/documentation/web-api/reference/#/operations/search
func searchForSong(_ songToSearchFor: String) async {
  let session = createSession()
  let SpotifySearchURL = "https://api.spotify.com/v1/search?q=\(songToSearchFor)&type=track"

  let searchTask = session.dataTask(with: URL(string: SpotifySearchURL)!) { (data, response, error) in
    guard let data = data else {
      print("Error: No data to decode")
      return
    }
    
    // Decode the JSON here
    guard let response = try? JSONDecoder().decode(SearchResponse.self, from: data) else {
      print("Error: Couldn't decode data into a result")
      return
    }
    
    // Output if everything is working right
    print("\(response)")
  }

  searchTask.resume()
}

// gets and parses the data for getting a song. This will be used for retrieving previous song of the day by the songID
// developer console: https://developer.spotify.com/console/get-track/
// documentation on get track API endpoint: https://developer.spotify.com/documentation/web-api/reference/#/operations/get-track
func getSongById(_ id: String) async {
  let session = await createSession()
  let SpotifyGetTrackURL = "https://api.spotify.com/v1/tracks/\(id)"
  

  
  let getTrackTask = session.dataTask(with: URL(string: SpotifyGetTrackURL)!) { (data, response, error) in
    guard let data = data else {
      print("Error: No data to decode")
      return
    }
    
    // Decode the JSON here
    guard let response = try? JSONDecoder().decode(Song.self, from: data) else {
      print("Error: Couldn't decode data into a result")
      return
    }
    
    // Output if everything is working right
    print("getsong by id\(response)")
  }
  
  getTrackTask.resume()
}
Task{
  do{
    let res = try await searchForSong("stitches")
    let res2 = try await getSongById("5jsw9uXEGuKyJzs0boZ1bT")
    print("here")
  }catch{
    print("error")
  }

}

