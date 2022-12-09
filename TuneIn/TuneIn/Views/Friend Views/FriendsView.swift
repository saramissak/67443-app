//
//  FriendsView.swift
//  TuneIn
//
//  Created by Luke Arney on 11/7/22.
//

import SwiftUI

struct FriendsView: View {
  @EnvironmentObject var viewModel: ViewModel
  @ObservedObject var friendsViewModel: FriendsViewModel
  @State private var friendsTab: Bool = true
  
  var body: some View {
    return VStack {
      tabs()
      if self.friendsTab {
        FriendsTab(viewModel: viewModel, friendsViewModel: friendsViewModel)
      } else {
        FindTab(viewModel: viewModel, friendsViewModel: friendsViewModel) // finds people
      }
    }
  }
  
  
  func tabs() -> some View {
    HStack {
      Spacer()
      if self.friendsTab {
        Button("find", action:{
          friendsViewModel.getFriendRequests(completionHandler: { (eventList) in })
          friendsViewModel.getFriends(completionHandler: { (eventList) in })
          self.friendsTab = false
        }).foregroundColor(viewModel.hexStringToUIColor(hex: "#FFFFFF"))
      } else {
        Button("find", action:{
          friendsViewModel.getFriendRequests(completionHandler: { (eventList) in })
          friendsViewModel.getFriends(completionHandler: { (eventList) in print(eventList)})
          self.friendsTab = false
        })
        .fixedSize(horizontal: false, vertical: false)
        .padding([.top, .bottom], 10)
        .padding([.trailing, .leading], 10)
        .foregroundColor(viewModel.hexStringToUIColor(hex: "#FFFFFF"))
        .background(viewModel.hexStringToUIColor(hex: "#373547"))
        .cornerRadius(10)
      }

      Spacer()
      if self.friendsTab {
        Button("friends", action:{
          friendsViewModel.getFriends(completionHandler: { (eventList) in print(eventList)})
          self.friendsTab = true
        }).fixedSize(horizontal: false, vertical: false)
          .padding([.top, .bottom], 10)
          .padding([.trailing, .leading], 10)
          .foregroundColor(viewModel.hexStringToUIColor(hex: "#FFFFFF"))
          .background(viewModel.hexStringToUIColor(hex: "#373547"))
          .cornerRadius(10)
      } else {
        Button("friends", action:{
          friendsViewModel.getFriends(completionHandler: { (eventList) in print(eventList)})
          self.friendsTab = true
        }).foregroundColor(viewModel.hexStringToUIColor(hex: "#FFFFFF"))
      }
      Spacer()
    }
  }
}
