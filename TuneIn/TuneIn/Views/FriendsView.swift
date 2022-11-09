//
//  FriendsView.swift
//  TuneIn
//
//  Created by Luke Arney on 11/7/22.
//

import SwiftUI

struct FriendsView: View {
  @ObservedObject var viewModel: ViewModel
  @ObservedObject var friendsViewModel: FriendsViewModel
  @State private var findTab: Bool = true
  
  var body: some View {
    return VStack {
      Text("Tune In").font(.title)
      HStack {
        Spacer()
        Button("find", action:{
          friendsViewModel.getFriendRequests()
          friendsViewModel.getFriends()
          self.findTab = false
        })
          
        Spacer()
        
        Button("friends", action:{
          friendsViewModel.getFriends()
          self.findTab = true
        })
        Spacer()
      }
      
      if self.findTab {
        SearchFriends(viewModel: viewModel, friendsViewModel: friendsViewModel)
      } else {
        SearchBar(viewModel: viewModel, friendsViewModel: friendsViewModel) // finds people
      }
    }
  }
}

//struct FriendsView_Previews: PreviewProvider {
//    static var previews: some View {
//      FriendsView(viewModel: ViewModel())
//    }
//}
