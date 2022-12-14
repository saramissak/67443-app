//
//  ContentView.swift
//  TuneIn
//
//  Created by Sara Missak on 10/14/22.
//

import SwiftUI
import Combine
import SpotifyWebAPI

struct ContentView: View {
  @EnvironmentObject var spotify: Spotify
  @ObservedObject var viewModel = ViewModel()
  @ObservedObject var friendsViewModel: FriendsViewModel = FriendsViewModel()
  @State var clickedLogin = false
  @State var selectedTab = 0
  @State private var alert: AlertItem? = nil
  @State private var cancellables: Set<AnyCancellable> = []
  var authorized = true
  
  init() {
    UITabBar.appearance().backgroundColor = UIColor.black
  }
 
  var body: some View {
    Header()
    if (viewModel.loggedIn && spotify.isAuthorized){
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
      .accentColor(.white)
      .environmentObject(viewModel)
      .onChange(of: selectedTab) { newValue in
        if selectedTab == 1 && friendsViewModel.friends.count == 0 {
          friendsViewModel.getFriends(completionHandler: { (eventList) in })
        }
      }
    } else{
      Button("Login with Spotify Credentials", action:{
        viewModel.login()
      })
    }
  }
}
