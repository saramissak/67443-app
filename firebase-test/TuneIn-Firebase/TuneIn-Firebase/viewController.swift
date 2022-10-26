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
    ref.child("UserInfo/name").setValue(name)
    ref.child("UserInfo/name").observeSingleEvent(of: .value){
      (snapshot) in
      let name = snapshot.value as? String
    }
    return name 
  }

  
}




