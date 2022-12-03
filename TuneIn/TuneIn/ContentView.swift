//
//  ContentView.swift
//  TuneIn
//
//  Created by Sara Missak on 10/14/22.
//

import SwiftUI
import Combine
import SpotifyWebAPI

struct ContentView: View {
  @EnvironmentObject var spotify: Spotify
  //@ObservedObject var spotify = Spotify()
  @ObservedObject var viewModel = ViewModel()
  @ObservedObject var friendsViewModel: FriendsViewModel = FriendsViewModel()
  @State var clickedLogin = false
  @State var selectedTab = 0
  @State private var alert: AlertItem? = nil
  @State private var cancellables: Set<AnyCancellable> = []
  
  init() {
    UITabBar.appearance().backgroundColor = UIColor.black
  }
  
  //  @State var received = false
  var authorized = true
  var body: some View {
    Header()
    if (viewModel.loggedIn && spotify.isAuthorized){
      TabView(selection: $selectedTab) {
        HomeFeed()
          .tabItem {
            Image(systemName: "music.note")
            Text("Home")
          }
          .tag(0)
        FriendsView(friendsViewModel: friendsViewModel)
          .tabItem {
            Image(systemName: "person.2.fill")
            Text("Friends")
          }
          .tag(1)
        NotificationsView(viewModel: viewModel)
          .tabItem {
            Image(systemName: "bell.fill")
            Text("Notifications")
          }
          .tag(2)
        ProfileView()
          .tabItem {
            Image(systemName: "person.circle.fill")
            Text("Profile")
          }
          .tag(3)
      }
      .environmentObject(viewModel)
      .onChange(of: selectedTab) { newValue in
        if selectedTab == 1 && friendsViewModel.friends.count == 0 {
          friendsViewModel.getFriends(completionHandler: { (eventList) in
            print("line 31 completionHandler done")
          })
        }
      }
    } else{
//      LoginView()
//      // Called when a redirect is received from Spotify.
//      .onOpenURL(perform: handleURL(_:))
      //      Text("Welcome to TuneIn")
      Button("Login with Spotify Credentials", action:{
        viewModel.login()
      })
//      .disabled(!spotify.isAuthorized)
      
        
      
    }
    
    
  }
  /**
   Handle the URL that Spotify redirects to after the user Either authorizes
   or denies authorization for the application.

   This method is called by the `onOpenURL(perform:)` view modifier directly
   above.
   */
  func handleURL(_ url: URL) {
      
      // **Always** validate URLs; they offer a potential attack vector into
      // your app.
      guard url.scheme == self.spotify.loginCallbackURL.scheme else {
          print("not handling URL: unexpected scheme: '\(url)'")
          self.alert = AlertItem(
              title: "Cannot Handle Redirect",
              message: "Unexpected URL"
          )
          return
      }
      
      print("received redirect from Spotify: '\(url)'")
      
      // This property is used to display an activity indicator in `LoginView`
      // indicating that the access and refresh tokens are being retrieved.
      spotify.isRetrievingTokens = true
      
      // Complete the authorization process by requesting the access and
      // refresh tokens.
      spotify.api.authorizationManager.requestAccessAndRefreshTokens(
          redirectURIWithQuery: url,
          // This value must be the same as the one used to create the
          // authorization URL. Otherwise, an error will be thrown.
          state: spotify.authorizationState
      )
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
          // Whether the request succeeded or not, we need to remove the
          // activity indicator.
          self.spotify.isRetrievingTokens = false
          
          /*
           After the access and refresh tokens are retrieved,
           `SpotifyAPI.authorizationManagerDidChange` will emit a signal,
           causing `Spotify.authorizationManagerDidChange()` to be called,
           which will dismiss the loginView if the app was successfully
           authorized by setting the @Published `Spotify.isAuthorized`
           property to `true`.

           The only thing we need to do here is handle the error and show it
           to the user if one was received.
           */
          if case .failure(let error) = completion {
              print("couldn't retrieve access and refresh tokens:\n\(error)")
              let alertTitle: String
              let alertMessage: String
              if let authError = error as? SpotifyAuthorizationError,
                 authError.accessWasDenied {
                  alertTitle = "You Denied The Authorization Request :("
                  alertMessage = ""
              }
              else {
                  alertTitle =
                      "Couldn't Authorization With Your Account"
                  alertMessage = error.localizedDescription
              }
              self.alert = AlertItem(
                  title: alertTitle, message: alertMessage
              )
          }
      })
      .store(in: &cancellables)
      
      // MARK: IMPORTANT: generate a new value for the state parameter after
      // MARK: each authorization request. This ensures an incoming redirect
      // MARK: from Spotify was the result of a request made by this app, and
      // MARK: and not an attacker.
      self.spotify.authorizationState = String.randomURLSafe(length: 128)
      
  }
  
  struct ContentView_Previews: PreviewProvider {
    
    static let spotify: Spotify = {
      let spotify = Spotify()
      spotify.isAuthorized = true
      return spotify
    }()
    
    static var previews: some View {
      ContentView()
    }
  }
  
}
