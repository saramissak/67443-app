//
//  HomeFeedTests.swift
//  TuneInTests
//
//  Created by The Family on 12/12/22.
//

import XCTest
import XCTest
@testable import TuneIn
import FirebaseFirestore
import Firebase
import FirebaseDatabase
import FirebaseFirestoreSwift
import Spartan

final class HomeFeedTests: XCTestCase {
  
    var viewModel = ViewModel()


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    func testSearchSong() throws {
      self.viewModel.searchSong("Picture in my mind", completionHandler: {(songs) in
        XCTAssertGreaterThan(songs.count, 0)
        XCTAssertEqual(songs[0].artist,"PinkPanthress")
                                                                           
      })

    }
  
  func testMakePosts() throws{
    // test
    let testToken = "BQC5gIjLy-PNwVzdNzGUTKlOEjriwutW-DEnmv-aA2MwFDASkW39AwB8f29ttWbjlDIQprh-Jo7UPJVt0pmTf_F5xmdFpScEG2VWgjKMuBqaYncF7l3x2_a0BbgOxQPwlHHmhaTnSRxQYVhdYTz6A-E6YH_VNFC3eKbljr7xb7jqNXvNKzFJo6-FHEA3w-lVgNQc83DO2d0"
      self.viewModel.login(authToken: testToken, completionHandler: {(eventList) in
        
        var newSong = Song()
        newSong.id = "0lizgQ7Qw35od7CYaoMBZb"
        newSong.artist = "Ariana Grande"
        newSong.songName = "Santa Tell Me"
        newSong.spotifyLink = "https://open.spotify.com/track/0lizgQ7Qw35od7CYaoMBZb"
        newSong.previewURL = "spotify:track:0lizgQ7Qw35od7CYaoMBZb"
        self.viewModel.makePost(song: newSong, caption: "test caption", moods: ["test mood", "test mood 2"])
        self.viewModel.getPosts(completionHandler: { posts in
          print("POSTS",posts)
          let filteredPosts = posts.filter{(id,post) -> Bool in
            post.song.id == newSong.id
          }
          XCTAssertFalse(filteredPosts.isEmpty)
          XCTAssertTrue(self.viewModel.hasPostedSongOfDay())
        
        })
      })
    
  }
  func testMakeComment() throws{
    let testToken = "BQC5gIjLy-PNwVzdNzGUTKlOEjriwutW-DEnmv-aA2MwFDASkW39AwB8f29ttWbjlDIQprh-Jo7UPJVt0pmTf_F5xmdFpScEG2VWgjKMuBqaYncF7l3x2_a0BbgOxQPwlHHmhaTnSRxQYVhdYTz6A-E6YH_VNFC3eKbljr7xb7jqNXvNKzFJo6-FHEA3w-lVgNQc83DO2d0"
    self.viewModel.login(authToken: testToken, completionHandler: {(eventList) in
      var fakePost = Post()
      fakePost.id = "1"
      
      self.viewModel.postComment(docID: "testID", comment:  "test comment", post: fakePost, completionHandler:{ comment in
        XCTAssertTrue(comment.postID == "1")
        self.viewModel.getCommentByCommentID(comment.id, completionHandler:{(text) in
          XCTAssertTrue(text == "text comment")
        })
        self.viewModel.getComments(post: fakePost, completionHandler:{(comments) in
          XCTAssertTrue(comments.count == 0)
        })
      })
      
      
    })
  }
  func testNotifications() throws{
    let testToken = "BQC5gIjLy-PNwVzdNzGUTKlOEjriwutW-DEnmv-aA2MwFDASkW39AwB8f29ttWbjlDIQprh-Jo7UPJVt0pmTf_F5xmdFpScEG2VWgjKMuBqaYncF7l3x2_a0BbgOxQPwlHHmhaTnSRxQYVhdYTz6A-E6YH_VNFC3eKbljr7xb7jqNXvNKzFJo6-FHEA3w-lVgNQc83DO2d0"
    self.viewModel.login(authToken: testToken, completionHandler: {(eventList) in
      self.viewModel.getNotifications(completionHandler: {(notifications) in
        XCTAssertTrue(notifications.count != 0)
        self.viewModel.makeCommentNotification(Comment())
        XCTAssertTrue(notifications.count > 0)
      })

    })
  }

}
