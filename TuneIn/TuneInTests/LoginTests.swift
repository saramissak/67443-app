//
//  LoginTests.swift
//  TuneInTests
//
//  Created by The Family on 12/7/22.
//

import XCTest
@testable import TuneIn
import FirebaseFirestore
import Firebase
import FirebaseDatabase
import FirebaseFirestoreSwift
import Spartan


final class LoginTests: XCTestCase {
  
  var viewModel = ViewModel()
//    override func setUp() throws {
//      viewModel = ViewModel()
//
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLogin() throws {
      viewModel.login()
      Spartan.authorizationToken = "BQC5gIjLy-PNwVzdNzGUTKlOEjriwutW-DEnmv-aA2MwFDASkW39AwB8f29ttWbjlDIQprh-Jo7UPJVt0pmTf_F5xmdFpScEG2VWgjKMuBqaYncF7l3x2_a0BbgOxQPwlHHmhaTnSRxQYVhdYTz6A-E6YH_VNFC3eKbljr7xb7jqNXvNKzFJo6-FHEA3w-lVgNQc83DO2d0"
      _ = Spartan.getMe(success: { (user) in
        // Do something with the user object
        print("USER \(user)")
        XCTAssertEqual(user.id as! String,"5t5kzptmezvdtdy40ni9xriti")
      }, failure: { (err) in
        print("cant find spotify ID in spartn", err)

      })
      
      var songs:[Song] = []
      _ = Spartan.search(query: "Picture in my mind", type: .track, success: { (pagingObject: PagingObject<SimplifiedTrack>) in
        for obj in pagingObject.items{
          var currSong = Song()
          currSong.id = obj.id as! String
          currSong.songName = obj.name
          currSong.artist = obj.artists[0].name
 
          if obj.externalUrls != nil {
            currSong.spotifyLink = obj.externalUrls!["spotify"] ?? ""
          }
          
          if obj.uri != nil {
            currSong.previewURL = obj.uri
          }
          songs.append(currSong)
        }
        
        print("SEARCHED SONGS \(songs)")
        XCTAssertGreaterThan(songs.count, 0)
        XCTAssertEqual(songs[0].artist,"PinkPanthress")
      }, failure: { (error) in
        print(error)
      })
      
      
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
