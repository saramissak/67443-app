//
//  TuneIn_FirebaseApp.swift
//  TuneIn-Firebase
//
//  Created by The Family on 10/26/22.
//

import SwiftUI
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}


@main
struct TuneIn_FirebaseApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
