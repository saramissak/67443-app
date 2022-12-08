//
//  FriendsTab.swift
//  TuneIn
//
//  Created by Sara Missak on 11/7/22.
//

import SwiftUI

struct FriendsTab: View {
  @ObservedObject var viewModel: ViewModel
  @ObservedObject var friendsViewModel: FriendsViewModel
  @State var searchField: String = ""
  @State var displayedUsers  = [UserInfo]()
  
  var body: some View {
    let binding = Binding<String>(get: {self.searchField},
                                  set: {
      self.searchField = $0
      self.displayedUsers = Array(self.friendsViewModel.searchedUsers.values)
      print("self.searchField \(self.searchField)")
    })
    
    VStack {
      SearchField(innerText: "Search Friends", binding: binding)

      
      ForEach(friendsViewModel.friends.sorted(by: >), id: \.key) { userID, _ in
        HStack{
          miniUserInfo(userID: userID).environmentObject(viewModel)
          Spacer()
          
          roundedRectangleButton(ButtonText: "remove", UserID: userID, TextHex: "FFFFFF", BackgroundHex: "373547")
            .environmentObject(viewModel)
            .environmentObject(friendsViewModel)
        }
      }
      Spacer()
    }
  }
}
