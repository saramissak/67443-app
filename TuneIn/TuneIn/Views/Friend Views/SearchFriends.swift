//
//  SearchFriends.swift
//  TuneIn
//
//  Created by Sara Missak on 11/7/22.
//

import SwiftUI

struct SearchFriends: View {
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
    
//    return NavigationView{
//      VStack {
//        HStack {
//          Image(systemName: "magnifyingglass")
//              .font(.system(size: 14.0, weight: .bold))
//          TextField("Search Friends", text: binding)
//            .autocapitalization(.none)
//            .disableAutocorrection(true)
//        }
//        Spacer()
//        
//        Text("Click on find instead for now!")
//        Spacer()
//        
//      }
//    }
    VStack {
      HStack {
        Image(systemName: "magnifyingglass")
            .font(.system(size: 14.0, weight: .bold))
        TextField("Search Friends", text: binding)
          .autocapitalization(.none)
          .disableAutocorrection(true)
      }
      Spacer()
      
      Text("Click on find instead for now!")
      Spacer()
      
    }
  }
}
