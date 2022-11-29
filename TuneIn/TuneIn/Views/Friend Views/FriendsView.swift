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
  @State private var findTab: Bool = true
  
  var body: some View {
    return VStack {
      HStack {
        Spacer()
        Button("find", action:{
          friendsViewModel.getFriendRequests()
          friendsViewModel.getFriends(completionHandler: { (eventList) in
            print("line 22 completionHandler done")
          })
          self.findTab = false
        })
          
        Spacer()
        
        Button("friends", action:{
          friendsViewModel.getFriends(completionHandler: { (eventList) in
            print("line 31 completionHandler done")
          })
          self.findTab = true
        })
        Spacer()
      }
      
      if self.findTab {
        FriendsTab(viewModel: viewModel, friendsViewModel: friendsViewModel)
      } else {
        FindTab(viewModel: viewModel, friendsViewModel: friendsViewModel) // finds people
      }
    }
  }
}

//struct FriendsView_Previews: PreviewProvider {
//    static var previews: some View {
//      FriendsView(viewModel: ViewModel())
//    }
//}
