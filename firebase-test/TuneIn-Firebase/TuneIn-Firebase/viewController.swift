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


class ViewController: UIViewController{
  override func viewDidLoad() {
    super.viewDidLoad()
    let ref = Database.database().reference()
    ref.child("UserInfo/name").setValue("new Name")
  }
}




