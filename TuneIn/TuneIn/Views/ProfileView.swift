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
    var body: some View {
      VStack{
        Header()
        ScrollView{
          VStack(alignment: .leading){
            ProfileBlock()
            ProfileSongOfDay()
            Spacer()
              .environmentObject(viewModel)
            //Text("username: \(viewModel.username)")
          }
        }
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
  var body: some View {
    HStack{
      Image("John_Smith")
        .resizable()
        .aspectRatio(contentMode: .fill)
        .frame(width: 150, height: 150)
        .clipShape(Circle())
        .clipped()
        .padding()
      VStack(alignment: .leading){
        Text("John Smith")
          .bold()
        ZStack{
          roundedRectangleText(bodyText: "Genre", TextHex: "#000000", BackgroundHex: "#B9C0FF")
        }
      }
      Spacer()
    }
    roundedRectangleText(
      bodyText: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sem integer vitae justo eget magna fermentum",
      TextHex: "#ECECEC",
      BackgroundHex: "#373547",
      alignment: .leading,
      topBottomPadding: 5,
      leftRightPadding: 5
    )
  }
}

struct ProfileSongOfDay : View {
  @EnvironmentObject var viewModel: ViewModel
  var body: some View {
    VStack(alignment: .leading){
      Text("What I am feeling today:")
        .bold()
      HStack(alignment: .top){
        Image("drake_album-S")
          .aspectRatio(contentMode: .fit)
          .frame(width: 100, height: 100)
          .clipped()
        VStack(alignment: .leading){
          Text("Song Name")
            .bold()
          Text("Drake")
          roundedRectangleText(bodyText: "Sad", TextHex: "#000000", BackgroundHex: "#B9C0FF")
        }
      }
      
    }
    .padding()
  }
}

struct PastSongsOfTheDay : View {
  
}

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
