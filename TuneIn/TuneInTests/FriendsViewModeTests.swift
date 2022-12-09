//
//  FriendsViewModeTests.swift
//  TuneInTests
//
//  Created by Sara Missak on 12/8/22.
//

import XCTest
@testable import TuneIn
import FirebaseFirestore
import Firebase
import FirebaseDatabase
import FirebaseFirestoreSwift
import Spartan

final class FriendsViewModeTests: XCTestCase {
  
  var friendsViewModel = FriendsViewModel()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

  func testGetUsers() throws {
    friendsViewModel.getUsers("tes", completionHandler: { (eventList) in
      XCTAssertEqual(eventList, "testUser")
    })
    
    friendsViewModel.getUsers("non existent user", completionHandler: { (eventList) in
      XCTAssertEqual(eventList, "")
    })
  }
  
  func testAddFriend() throws {
    friendsViewModel.addFriend("testUser", completionHandler: { (eventList) in
      XCTAssertEqual(eventList, true)
      XCTAssertEqual(self.friendsViewModel.sentFriendRequest["testUser"] != nil, true)
    })
  }
  
  func testAddFriendInFirestore() throws {
    friendsViewModel.addFriendInFirestore("testUser", completionHandler: { (eventList) in
      XCTAssertEqual(eventList, true)
      XCTAssertEqual(self.friendsViewModel.sentFriendRequest["testUser"] != nil, true)
    })
  }
  
  func testAcceptFriend() throws {
    friendsViewModel.acceptFriend("testUser", completionHandler: { eventList in
      XCTAssertEqual(eventList, "testUser")
      XCTAssertEqual(self.friendsViewModel.friends["testUser"] != nil, true)
    })
  }

  func testAcceptFriendInFirestore() throws {
    friendsViewModel.acceptFriendInFireStore("testUser", completionHandler: { eventList in
      XCTAssertEqual(eventList, "testUser")
      XCTAssertEqual(self.friendsViewModel.friends["testUser"] != nil, true)
    })
  }
  
  func testRemoveFriendRequest() throws {
    friendsViewModel.removeFriendRequest("testUser", completionHandler: { eventList in
      XCTAssertEqual(eventList, true)
      XCTAssertEqual(self.friendsViewModel.receivedFriendRequest["testUser"] == nil, true)
    })
  }
  
  func testGetFriendRequests() throws {
    friendsViewModel.getFriendRequests(completionHandler: { eventList in
      XCTAssertEqual(eventList, "testUser2")
      XCTAssertEqual(self.friendsViewModel.receivedFriendRequest[eventList] != nil, true)
    })
  }
  
  func testGetFriendsFireStoreCall() throws {
    friendsViewModel.getFriendsFireStoreCall(completionHandler: { eventList in
      XCTAssertEqual(eventList, "testUser2")
      XCTAssertEqual(self.friendsViewModel.receivedFriendRequest[eventList] != nil, true)
    })
  }
  
  func testRemoveFriend() throws {
    friendsViewModel.removeFriend("testUser", completionHandler: { eventList in
      XCTAssertEqual(eventList, true)
      XCTAssertEqual(self.friendsViewModel.friends["testUser"] == nil, true)
    })
  }

}
