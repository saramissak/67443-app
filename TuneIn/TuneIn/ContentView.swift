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
  var authorized = true
    var body: some View {
      Button("get posts", action: viewModel.getPosts)

      TabView {
        HomeFeed()
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
      .environmentObject(viewModel)
      
//      DispatchQueue.main.async {
//        viewModel.getPosts()
//      }
//        if received == false {
//        viewModel.getPosts()
//        received = true
//      }
                    
//      Button("Get Posts", action:{
//        viewModel.getPosts()
//      })
//      return HomeFeed(viewModel: viewModel)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
