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
  
  //  @State var received = false
  var authorized = true
  var body: some View {
    Header()
    if viewModel.loggedIn{
      TabView {
        HomeFeed()
          .tabItem {
            Image(systemName: "music.note")
            Text("Home")
          }
        FriendsView(friendsViewModel: friendsViewModel)
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
      .environmentObject(viewModel)
      
      
    } else{
      //      Text("Welcome to TuneIn")
      Button("Login with Spotify Credentials", action:{
        viewModel.login()
      })
      //      Button("Login",action:{
      //        clickedLogin = true
      //        viewModel.userExists()
      //        DispatchQueue.main.asyncAfter(deadline: .now()+30){
      //          if clickedLogin{
      //            if viewModel.userExisting{
      //              Button("Login with Spotify Credentials",action:{
      //                viewModel.login()
      //              })
      //            } else{
      //              NavigationLink(destination: createUserView(), label:{
      //                Text("Create Account with Spotify Credentials")
      //              })
      //            }
      //          }
      //        }
      //      })
      
      
      
    }
  }
  
}

