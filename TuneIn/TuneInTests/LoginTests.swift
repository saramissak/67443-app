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
      Spartan.authorizationToken = "BQC5gIjLy-PNwVzdNzGUTKlOEjriwutW-DEnmv-aA2MwFDASkW39AwB8f29ttWbjlDIQprh-Jo7UPJVt0pmTf_F5xmdFpScEG2VWgjKMuBqaYncF7l3x2_a0BbgOxQPwlHHmhaTnSRxQYVhdYTz6A-E6YH_VNFC3eKbljr7xb7jqNXvNKzFJo6-FHEA3w-lVgNQc83DO2d0"
      let testToken = "BQC5gIjLy-PNwVzdNzGUTKlOEjriwutW-DEnmv-aA2MwFDASkW39AwB8f29ttWbjlDIQprh-Jo7UPJVt0pmTf_F5xmdFpScEG2VWgjKMuBqaYncF7l3x2_a0BbgOxQPwlHHmhaTnSRxQYVhdYTz6A-E6YH_VNFC3eKbljr7xb7jqNXvNKzFJo6-FHEA3w-lVgNQc83DO2d0"
      self.viewModel.login(authToken: testToken, completionHandler: {(eventList) in
        XCTAssertTrue(self.viewModel.loggedIn)
        XCTAssertEqual(self.viewModel.spotifyID,"5t5kzptmezvdtdy40ni9xriti")
      })

      _ = Spartan.getMe(success: { (user) in
        // Do something with the user object
        print("USER \(user)")
        XCTAssertEqual(user.id as! String,"5t5kzptmezvdtdy40ni9xriti")
      }, failure: { (err) in
        print("cant find spotify ID in spartn", err)

      })
    
    }
  func testGetUsers() throws {
    viewModel.getUserById("testUser", completionHandler: { (user) in
      XCTAssertEqual(user.spotifyID, "testUser")
    })
    
    viewModel.getUserById("non existent user", completionHandler: { (user) in
      XCTAssertEqual(user.spotifyID, "")
    })
  }
  
  func testEditBio() throws {
    let newBio = " test test bio"
    let newName = "test test"
    let newUsername = "testUserName"
    let newGenre = "testing"
    let oldBio = ""
    let oldName = "test"
    let oldUsername = "testUser"
    let oldGenre = ""
    let testUserSpotifyID = "testUser"
    viewModel.getUserById("testUser", completionHandler: { (user) in
      self.viewModel.editAccount(bio:newBio)
      XCTAssertEqual(user.spotifyID, testUserSpotifyID)
      XCTAssertEqual(user.bio, newBio)
      XCTAssertEqual(user.name, oldName)
      XCTAssertEqual(user.username, oldUsername)
      XCTAssertEqual(user.favoriteGenre, oldGenre)
      
      self.viewModel.editAccount(name: newName)
      XCTAssertEqual(user.spotifyID, testUserSpotifyID)
      XCTAssertEqual(user.bio, newBio)
      XCTAssertEqual(user.name, newName)
      XCTAssertEqual(user.username, oldUsername)
      XCTAssertEqual(user.favoriteGenre, oldGenre)
      
      self.viewModel.editAccount(username: newUsername)
      XCTAssertEqual(user.spotifyID, testUserSpotifyID)
      XCTAssertEqual(user.bio, newBio)
      XCTAssertEqual(user.name, newName)
      XCTAssertEqual(user.username, newUsername)
      XCTAssertEqual(user.favoriteGenre, oldGenre)
      
      self.viewModel.editAccount(genre: newGenre)
      XCTAssertEqual(user.spotifyID, testUserSpotifyID)
      XCTAssertEqual(user.bio, newBio)
      XCTAssertEqual(user.name, newName)
      XCTAssertEqual(user.username, newUsername)
      XCTAssertEqual(user.favoriteGenre, newGenre)
      
      self.viewModel.editAccount(bio:oldBio, name: oldName, username: oldUsername, genre: oldGenre)
      XCTAssertEqual(user.spotifyID, testUserSpotifyID)
      XCTAssertEqual(user.bio, oldBio)
      XCTAssertEqual(user.name, oldName)
      XCTAssertEqual(user.username, oldUsername)
      XCTAssertEqual(user.favoriteGenre, oldGenre)
      
    })
    
  }


}
