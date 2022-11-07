//
//  ContentView.swift
//  TuneIn
//
//  Created by Sara Missak on 10/14/22.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var viewModel = ViewModel()
//  @State var received = false
  
    var body: some View {
      TabView {
        HomeFeed(viewModel: viewModel)
        .tabItem {
          Image(systemName: "music.note")
          Text("Home")
        }
        FriendsView(viewModel: viewModel)
          .tabItem {
            Image(systemName: "person.2.fill")
            Text("Friends")
          }
        NotificationsView(viewModel: viewModel)
          .tabItem {
            Image(systemName: "bell.fill")
            Text("Notifications")
          }
        ProfileView()
          .tabItem {
            Image(systemName: "person.circle.fill")
            Text("Profile")
          }
      }
      Button("Get Posts", action:{
        viewModel.getPosts()
      })
//      return HomeFeed(viewModel: viewModel)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
