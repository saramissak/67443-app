import UIKit
import Foundation

let bearerToken = ""

let SpotifyURL = URL(string: "https://api.spotify.com/v1/search?q=stitches&type=track")!
var SpotifyRequets = URLRequest(url: SpotifyURL)

var sessionConfiguration = URLSessionConfiguration.default // 5

sessionConfiguration.httpAdditionalHeaders = [
    "Authorization": "Bearer \(bearerToken)" // 6
]

let session = URLSession(configuration: sessionConfiguration)

let cancellable = session
    .dataTaskPublisher(for: SpotifyRequets) //5
    .sink(receiveCompletion: { completion in
        switch completion {
        case let .failure(reason):
            print(reason)
        case .finished:
            print("Done without errors")
        }
    }) { receivedValue in
        print( //6
            String(data: receivedValue.data, encoding: .utf8) ?? "Unknown"
        )
    }
