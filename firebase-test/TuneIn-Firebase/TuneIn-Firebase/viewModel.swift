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
//  private let path: String = "UserInfo"
  private var getUsers: [UserInfo] = []
  private let ref = Database.database().reference()
  
  
  init(){
    
    var user1 = UserInfo(id:"1" ,username: "stella",name: "stella yan", spotifyID: "fakeID", profileImage: "")
    //    users.append(user1)
        var user2 = UserInfo(id:"2" ,username: "sara", name: "sara missak", spotifyID: "fakeID2", profileImage: "")
    //    users.append(user2)
    //    let user3 = UserInfo(id:"3",username: "luke", name: "luke arney", spotifyID: "fakeID3", profileImage: "")
    //    users.append(user3)
    //    users.forEach{ user in
    //      add(user)
    //    }
  }
  func add(_ user: UserInfo) {
    do {
      let newUser = userf
      _ = try store.collection("UserInfo").addDocument(from: newUser)
    } catch {
      fatalError("Unable to add book: \(error.localizedDescription).")
    }
  }

  func getUserByID(_ id:String){

    let docRef = store.collection("UserInfo").document(id)
    docRef.getDocument { (document, error) in
      if let document = document, document.exists {
        let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
        print("Document data: \(dataDescription)")
      } else {
        print("Document does not exist")
        return
      }
    }
  }
  func getAllUsers(){
    store.collection("UserInfo").getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                print("\(document.documentID) => \(document.data())")
            }
        }
    }
  }
  
  func remove(_ user: UserInfo) {
    guard let userID = user.id else { return }
    
    store.collection("UserInfo").document(userID).delete { error in
      if let error = error {
        print("Unable to remove book: \(error.localizedDescription)")
      }
    }
  }
  
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





