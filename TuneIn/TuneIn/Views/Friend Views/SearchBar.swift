//
//  SearchBar.swift
//  TuneIn
//
//  Created by Sara Missak on 11/7/22.
//

import SwiftUI

struct SearchBar: View {
  @ObservedObject var viewModel: ViewModel
  @ObservedObject var friendsViewModel: FriendsViewModel

  @State var searchField: String = ""
  @State var displayedUsers  = [UserInfo]()
  
    var body: some View {
      
      let binding = Binding<String>(get: {self.searchField},
        set: {
        self.searchField = $0
        self.friendsViewModel.getUsers(self.searchField)
        self.displayUsers()
        print("self.searchField \(self.searchField)")
      })
      
      return NavigationView{
        VStack {
          HStack {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14.0, weight: .bold))
            TextField("Search All Users", text: binding)
              .autocapitalization(.none)
              .disableAutocorrection(true)
          }
          
          ForEach (displayedUsers) { user in
            if user.username.contains(searchField) && user.spotifyID != viewModel.spotifyID {
              HStack {
//                Text("\(user.username)")
                miniUserInfo(userID:user.username).environmentObject(viewModel)
                Spacer()
                if friendsViewModel.receivedFriendRequest[user.spotifyID] != nil { // have received a friend request from them
                  roundedRectangleButton(ButtonText: "accept", Username: user.username, TextHex: "FFFFFF", BackgroundHex: "373547")
                    .environmentObject(viewModel)
                    .environmentObject(friendsViewModel)
                  roundedRectangleButton(ButtonText: "decline", Username: user.username, TextHex: "FFFFFF", BackgroundHex: "373547")
                    .environmentObject(viewModel)
                    .environmentObject(friendsViewModel)
                } else if friendsViewModel.sentFriendRequest[user.spotifyID] != nil {
                  roundedRectangleButton(ButtonText: "requested", Username: user.username, TextHex: "FFFFFF", BackgroundHex: "373547")
                    .environmentObject(viewModel)
                    .environmentObject(friendsViewModel)
                } else if friendsViewModel.friends[user.spotifyID] != nil {
                  roundedRectangleButton(ButtonText: "remove", Username: user.username, TextHex: "FFFFFF", BackgroundHex: "373547")
                    .environmentObject(viewModel)
                    .environmentObject(friendsViewModel)
                } else {
                  roundedRectangleButton(ButtonText: "add", Username: user.username, TextHex: "FFFFFF", BackgroundHex: "373547")
                    .environmentObject(viewModel)
                    .environmentObject(friendsViewModel)
                }
              }.frame(alignment: .top)
             } // if condition end
            } // end foreach
          Spacer()
          }
        }
    }
      
  func displayUsers() {
    if searchField == "" {
      displayedUsers = []
      print("viewModel.searchedUsers is now \(friendsViewModel.searchedUsers)")
    } else {
      displayedUsers = Array(friendsViewModel.searchedUsers.values)
      print(displayedUsers)
    }
  }
}


struct roundedRectangleButton : View {
  @EnvironmentObject var friendsViewModel: FriendsViewModel
  @EnvironmentObject var viewModel: ViewModel
  var ButtonText: String
  var Username: String
  var TextHex: String
  var BackgroundHex: String
  var alignment: TextAlignment? = .center
  var topBottomPadding: CGFloat? = 5
  var leftRightPadding: CGFloat? = 20
  var body: some View {
    Button(ButtonText, action:{
      switch ButtonText {
      case "add":
        friendsViewModel.addFriend(Username)
      case "accept":
        friendsViewModel.acceptFriend(Username)
      case "decline":
        friendsViewModel.removeFriendRequest(Username)
      case "requested":
        print("already sent a friend requst")
      case "remove":
        friendsViewModel.removeFriend(Username)
      default:
        print("\(ButtonText) is not a valid Buttontext")
      }
    })
        .fixedSize(horizontal: false, vertical: true)
        .multilineTextAlignment(alignment ?? .center)
        .padding([.top, .bottom], topBottomPadding)
        .padding([.trailing, .leading], leftRightPadding)
        .foregroundColor(viewModel.hexStringToUIColor(hex: TextHex))
        .background(viewModel.hexStringToUIColor(hex: BackgroundHex))
        .cornerRadius(8)
  }
}
