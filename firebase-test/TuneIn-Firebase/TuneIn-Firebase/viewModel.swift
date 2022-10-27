//
//  viewController.swift
//  TuneIn-Firebase
//
//  Created by The Family on 10/26/22.
//

import Foundation
import Firebase
import UIKit
import FirebaseDatabase


class Test{
  private var users:[UserInfo] = []
  private let store = Firestore.firestore()
  private let path: String = "UserInfo"
  
  private let ref = Database.database().reference()


  init(){
    
    let user1 = UserInfo(id:"1" ,username: "stella",name: "stella yan", spotifyID: "fakeID", profileImage: "")
    users.append(user1)
    let user2 = UserInfo(id:"2" ,username: "sara", name: "sara missak", spotifyID: "fakeID2", profileImage: "")
    users.append(user2)
    let user3 = UserInfo(id:"3",username: "luke", name: "luke arney", spotifyID: "fakeID3", profileImage: "")
    users.append(user3)
    users.forEach{ user in
      add(user)
    }
    updateName("1", name: "newNmae !")
  }
  func add(_ user: UserInfo) {
    ref.child("UserInfo").child(user.id).setValue(["id":user.id,"username":user.username])
    print(ref.child("UserInfo").child(String(0)))
  }
  
  func updateName(_ id: String, name: String){
    ref.child("UserInfo").child(id).setValue(["id":id, "name":name]) {
      (error:Error?, ref:DatabaseReference) in
      if let error = error {
        print("Data could not be saved: \(error).")
      } else {
        print("Data saved successfully!")
      }
    }  }
  
  func setName(name: String) -> String{
    let ref = Database.database().reference()
    // How to add user to UserInfo table
//    ref.child("UserInfo").child(UUID().uuidString).setValue(
//      ["name": "John",
//        "username": "john.smith"]
//       )
    let uid = 123
    ref.child("UserInfo").child("\(uid)/name").getData(completion:  { error, snapshot in
      guard error == nil else {
        print(error!.localizedDescription)
        return;
      }
      let name = snapshot?.value as? String ?? "Unknown";
    });
    return name 
  }

  
}






