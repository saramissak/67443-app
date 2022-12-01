//
//  PostCard.swift
//  TuneIn
//
//  Created by Sara Missak on 11/4/22.
//

import SwiftUI
import WrappingStack


struct PostCard: View {
  var post: Post
  var docID: String
  var displayCommentButton: Bool
  var iconSize = CGFloat(35)
  var width: CGFloat?
  var height: CGFloat?
  @EnvironmentObject var viewModel: ViewModel
  @State var viewComment: Bool = false
  @State var albumImage = UIImage()
  @State var shouldShowShareSheet: Bool = false
  
  var body: some View {
    VStack{
      HStack{
        miniUserInfo(userID:post.userID).environmentObject(viewModel)
      }
      VStack(){
        HStack{
          Image(uiImage: albumImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 150, height: 150)
            .clipped()
            .contentShape(Rectangle())
            .task {
              let url = URL(string: post.song.albumURL)
              let data = try? Data(contentsOf:url ?? URL(fileURLWithPath: ""))
              if let imageData = data {
                self.albumImage = UIImage(data: imageData)!
              }
            }
          VStack{
            VStack{
              Text("\(post.song.songName)").font(.body).fontWeight(.bold).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
              Text("By: \(post.song.artist)").font(.body).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
            }.padding([.top,.bottom],10)

            Spacer()
            HStack {
              if displayCommentButton {
                NavigationLink(destination: CommentScreen(post: post, docID: docID).environmentObject(viewModel), isActive: $viewComment, label: {
                  Image(systemName: "captions.bubble.fill").font(.system(size: iconSize))
                })
                .onChange(of: viewComment) { (newValue) in
                  viewModel.getComments(post:post)
                }
                .navigationBarBackButtonHidden(true)
              }
              
              if post.likes.contains(viewModel.user.id) {
                Button {
                  viewModel.unlikePost(post: post)
                } label: {
                  Image(systemName: "heart.fill").font(.system(size: iconSize))
                }
                
              } else {
                Button {
                  viewModel.likePost(post)
                } label: {
                  Image(systemName: "heart").font(.system(size: iconSize))
                }
              }
              
              if post.song.spotifyLink != "" {
                Button {
                  self.shouldShowShareSheet = true
                } label: {
                  Image(systemName: "square.and.arrow.up").font(.system(size: iconSize))
                }
              }
              
                
            }.frame(alignment: .center)
              .sheet(isPresented: self.$shouldShowShareSheet) {
                if let url: URL = URL(string: post.song.spotifyLink) {
                  ShareSheet(activityItems: [url])
                }
              }
          }.padding([.leading],10)
          
        }.frame(maxWidth: .infinity, alignment: .leading)
        Spacer()
        WrappingHStack(id: \.self, alignment: .leading){
          ForEach(post.moods, id: \.self) { mood in
            roundedRectangleText(bodyText: mood, TextHex: "#000000", BackgroundHex: "#FFED95")    .padding(2)
          }
        }
        Text("\(post.caption)").font(.system(size:15)).fontWeight(.light)
          .fixedSize(horizontal: false, vertical: true).lineLimit(nil).aspectRatio(contentMode: .fit).frame(maxWidth: .infinity, alignment: .leading)
      }.fixedSize(horizontal: false, vertical: false)
        .padding([.top, .bottom], 10)
        .padding([.trailing, .leading], 10)
        .foregroundColor(viewModel.hexStringToUIColor(hex: "#FFFFFF"))
        .background(viewModel.hexStringToUIColor(hex: "#373547"))
        .cornerRadius(8)
        .frame(width: width,height: height)
      
    }.padding([.trailing, .leading], 20)
  }
  
}
