//
//  SearchFriends.swift
//  TuneIn
//
//  Created by Sara Missak on 11/7/22.
//

import SwiftUI

struct SearchFriends: View {
  @ObservedObject var viewModel: ViewModel
  @State var searchField: String = ""
  @State var displayedUsers  = [UserInfo]()
  
  var body: some View {
    let binding = Binding<String>(get: {self.searchField},
      set: {
      self.searchField = $0
      self.viewModel.getFriends(self.searchField)
      self.displayFriends()
      print("self.searchField \(self.searchField)")
    })
    
    return NavigationView{
      VStack {
        Spacer()
        HStack {
          Image(systemName: "magnifyingglass")
              .font(.system(size: 14.0, weight: .bold))
          TextField("Search Friends", text: binding)
            .autocapitalization(.none)
            .disableAutocorrection(true)
        }
        
        List (displayedUsers) { user in
            HStack {
              Text("\(user.username)")
              Spacer()
              
              Button("add", action:{
                print("add is clicked")
              }).background( Color.black )
                .foregroundColor(.white)
                .cornerRadius(6)
            }
            
          }
        }
      }
  }
  
  func displayFriends() {
    if searchField == "" {
      displayedUsers = []
      viewModel.friends = [:]
      print("viewModel.searchedUsers is now \(viewModel.friends)")
    } else {
      displayedUsers = Array(viewModel.friends.values)
    }
  }
  
}

//struct SearchFriends_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchFriends()
//    }
//}
