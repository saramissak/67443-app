//
//  SearchBar.swift
//  TuneIn
//
//  Created by Sara Missak on 11/7/22.
//

import SwiftUI

struct SearchBar: View {
  @ObservedObject var viewModel: ViewModel
  @State var searchField: String = ""
  @State var displayedUsers  = [UserInfo]()
  
    var body: some View {
      
      let binding = Binding<String>(get: {self.searchField},
        set: {
        self.searchField = $0
        self.viewModel.getUsers(self.searchField)
        self.displayUsers()
        print("self.searchField \(self.searchField)")
      })
      
      return NavigationView{
        VStack {
          Spacer()
          HStack {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14.0, weight: .bold))
            TextField("Search All Users", text: binding)
              .autocapitalization(.none)
              .disableAutocorrection(true)
          }
          
          List (displayedUsers) { user in
            HStack {
              Text("\(user.username)")
              Spacer()
              HStack {
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
       
    }
      
  func displayUsers() {
    if searchField == "" {
      displayedUsers = []
      viewModel.searchedUsers = [:]
      print("viewModel.searchedUsers is now \(viewModel.searchedUsers)")
    } else {
      displayedUsers = Array(viewModel.searchedUsers.values)
    }
  }
}

//struct SearchBar_Previews:
//  PreviewProvider {
//    static var previews: some View {
//        SearchBar()
//    }
//}
