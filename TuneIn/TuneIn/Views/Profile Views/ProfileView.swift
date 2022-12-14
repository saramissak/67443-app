//
//  ProfileView.swift
//  TuneIn
//
//  Created by Luke Arney on 11/7/22.
//

import SwiftUI
import Spartan
import WrappingStack

struct ProfileView: View {
  @EnvironmentObject var viewModel: ViewModel
  var spotifyID : String {
    get {
      return "\(viewModel.username)"
    }
  }
    var body: some View {
      NavigationView{
        VStack{
          ScrollView{
            VStack(alignment: .leading){
              ProfileBlock(spotifyID: spotifyID, user: viewModel.user, madePost: false)
              ProfileSongOfDay()
              Spacer()
                .environmentObject(viewModel)
            }
          }
        } .navigationBarTitle("")
          .navigationBarHidden(true)
      }
    }
}

struct Header : View {
  var body : some View {
    Text("TuneIn")
      .font(.title2)
      .bold()
  }
}

struct ProfileBlock : View {
  @EnvironmentObject var viewModel: ViewModel
  @State private var showEditBioView: Bool = false
  var spotifyID: String
  var user: UserInfo
  var madePost: Bool
  var body: some View {
    HStack{
      Image(uiImage: viewModel.pfp)
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 150, height: 150)
        .clipShape(Circle())
        .clipped()
        .padding()
        .task {
          viewModel.getProfilePic()
        }
      VStack(alignment: .leading){
        Text("\(user.name)")
          .task {
            viewModel.getSelf(completionHandler: { (eventList) in })
          }
        Text("\(user.username)")
          .bold()
        if !user.favoriteGenre.isEmpty{
          roundedRectangleText(bodyText: "\(user.favoriteGenre)", TextHex: "#000000", BackgroundHex: "#B9C0FF")
        } else {
          roundedRectangleText(bodyText: "put fav genre here", TextHex: "#000000", BackgroundHex: "#B9C0FF")
        }
        
      }
      Spacer()
    }
      // need to allow to edit bio
      if user.bio != "" {
        roundedRectangleText(
          bodyText: user.bio,
          TextHex: "#ECECEC",
          BackgroundHex: "#373547",
          alignment: .leading,
          topBottomPadding: 5,
          leftRightPadding: 5
        )
      }
    VStack{
      NavigationLink(destination: SetBioView(user: user).environmentObject(viewModel), isActive: $showEditBioView){
        Button(action: {
          showEditBioView = true
        }){
          Text("Change Bio")
        }
      }
    }
  }
}

struct ProfileSongOfDay : View {
  @EnvironmentObject var viewModel: ViewModel
  @State var latestPost = Post()
  @State var albumImage = UIImage()
  var body: some View {
    if viewModel.getLatestUserPostID(userID: viewModel.user.spotifyID) != ""{
      VStack(alignment: .leading){
        Text("What I am feeling today:")
          .bold()
        HStack(alignment: .top){
          Image(uiImage: albumImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
            .clipped()
            .contentShape(Rectangle()) 
          VStack(alignment: .leading){
            Text("\(latestPost.song.songName)")
              .bold()
            Text("\(latestPost.song.artist)")
            WrappingHStack(id: \.self, alignment: .leading){
              ForEach(latestPost.moods, id: \.self) { mood in
                roundedRectangleText(bodyText: mood, TextHex: "#000000", BackgroundHex: "#FFED95")    .padding(2)
              }
            }
          }
        }
        .task {
          latestPost = viewModel.posts[viewModel.getLatestUserPostID(userID: viewModel.user.spotifyID)]!
          let url = URL(string: latestPost.song.albumURL)
          let data = try? Data(contentsOf:url ?? URL(fileURLWithPath: ""))
          if let imageData = data {
            self.albumImage = UIImage(data: imageData)!
          }
        }
        
      }
      .padding()
    }
  }
}
