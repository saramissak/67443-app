//
//  ContentView.swift
//  TuneIn
//
//  Created by Sara Missak on 10/14/22.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var viewModel = ViewModel()
  @ObservedObject var friendsViewModel: FriendsViewModel = FriendsViewModel()
  @State var clickedLogin = false
  @State var selectedTab = 0
  
  init() {
    UITabBar.appearance().backgroundColor = UIColor.black
  }
  
  //  @State var received = false
  var authorized = true
  var body: some View {
    Header()
    if viewModel.loggedIn{
      TabView(selection: $selectedTab) {
        HomeFeed()
          .tabItem {
            Image(systemName: "music.note")
            Text("Home")
          }
          .tag(0)
        FriendsView(friendsViewModel: friendsViewModel)
          .tabItem {
            Image(systemName: "person.2.fill")
            Text("Friends")
          }
          .tag(1)
        NotificationsView()
          .tabItem {
            Image(systemName: "bell.fill")
            Text("Notifications")
          }
          .tag(2)
        ProfileView()
          .tabItem {
            Image(systemName: "person.circle.fill")
            Text("Profile")
          }
          .tag(3)
      }
      .environmentObject(viewModel)
      .onChange(of: selectedTab) { newValue in
        if selectedTab == 1 && friendsViewModel.friends.count == 0 {
          friendsViewModel.getFriends(completionHandler: { (eventList) in
            print("line 31 completionHandler done")
          })
        }
      }
    } else{
      //      Text("Welcome to TuneIn")
      Button("Login with Spotify Credentials", action:{
        viewModel.login()
      })

    }
  }
  
}

