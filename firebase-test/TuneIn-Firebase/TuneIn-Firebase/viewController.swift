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




