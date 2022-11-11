//
//  ProfileView.swift
//  TuneIn
//
//  Created by Luke Arney on 11/7/22.
//

import SwiftUI
import Spartan
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
          Header()
          ScrollView{
            VStack(alignment: .leading){
              ProfileBlock(spotifyID: spotifyID, user: viewModel.user, madePost: false)
              ProfileSongOfDay()
              Spacer()
                .environmentObject(viewModel)
            }
          }
        }
      }
      
      
    }
}

struct Header : View {
  var body : some View {
    Text("Tune-in")
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
            viewModel.getSelf()
          }
        Text("\(spotifyID)")
          .bold()
        ZStack{
          roundedRectangleText(bodyText: "Genre", TextHex: "#000000", BackgroundHex: "#B9C0FF")
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
        Button(action: {showEditBioView = true}){
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
    VStack(alignment: .leading){
      Text("What I am feeling today:")
        .bold()
      HStack(alignment: .top){
        Image(uiImage: albumImage)
          .aspectRatio(contentMode: .fit)
          .frame(width: 100, height: 100)
          .clipped()
        VStack(alignment: .leading){
          Text("\(latestPost.song.songName)")
            .bold()
          Text("\(latestPost.song.artist)")
          roundedRectangleText(bodyText: "Sad", TextHex: "#000000", BackgroundHex: "#B9C0FF")
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

//struct PastSongsOfTheDay : View {
//  var body: some View {
//
//  }
//
//}

struct roundedRectangleText : View {
  @EnvironmentObject var viewModel: ViewModel
  var bodyText: String
  var TextHex: String
  var BackgroundHex: String
  var alignment: TextAlignment? = .center
  var topBottomPadding: CGFloat? = 5
  var leftRightPadding: CGFloat? = 20
  var body: some View {
    Text(bodyText)
        .fixedSize(horizontal: false, vertical: true)
        .multilineTextAlignment(alignment ?? .center)
        .padding([.top, .bottom], topBottomPadding)
        .padding([.trailing, .leading], leftRightPadding)
        .foregroundColor(viewModel.hexStringToUIColor(hex: TextHex))
        .background(viewModel.hexStringToUIColor(hex: BackgroundHex))
        .cornerRadius(8)
  }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
