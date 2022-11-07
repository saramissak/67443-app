//
//  ContentView.swift
//  TuneIn
//
//  Created by Sara Missak on 10/14/22.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var viewModel = ViewModel()
  @State var received = false
    var body: some View {
      TabView {
        HomeFeed(viewModel: viewModel)
        .tabItem {
          Image(systemName: "")
          Text("Home")
        }
        FriendsView()
          .tabItem {
            Image(systemName: "")
            Text("Friends")
          }
        NotificationsView()
          .tabItem {
            Image(systemName: "")
            Text("Notifications")
          }
        ProfileView()
          .tabItem {
            Image(systemName: "")
            Text("Profile")
          }
      }
      
//      DispatchQueue.main.async {
//        viewModel.getPosts()
//      }
//        if received == false {
//        viewModel.getPosts()
//        received = true
//      }
                    
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
