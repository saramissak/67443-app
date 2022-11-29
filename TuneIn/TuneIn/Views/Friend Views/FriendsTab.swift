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
      HStack {
        Image(systemName: "magnifyingglass")
          .font(.system(size: 14.0, weight: .bold))
        TextField("Search Friends", text: binding)
          .autocapitalization(.none)
          .disableAutocorrection(true)
      }
      
      ForEach(friendsViewModel.friends.sorted(by: >), id: \.key) { userID, _ in
        HStack{
          miniUserInfo(userID: userID).environmentObject(viewModel)
          Spacer()
          
          Button("remove", action:{
            friendsViewModel.removeFriendById(userID)
          })
          .fixedSize(horizontal: false, vertical: true)
          .padding([.top, .bottom], 5)
          .padding([.trailing, .leading], 20)
          .foregroundColor(viewModel.hexStringToUIColor(hex: "FFFFFF"))
          .background(viewModel.hexStringToUIColor(hex: "373547"))
          .cornerRadius(8)
        }
      }
      Spacer()
    }
  }
}
