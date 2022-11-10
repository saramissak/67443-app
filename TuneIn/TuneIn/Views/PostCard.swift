//
//  PostCard.swift
//  TuneIn
//
//  Created by Sara Missak on 11/4/22.
//

import SwiftUI

struct PostCard: View {
  var post: Post
  var docID: String
  @EnvironmentObject var viewModel: ViewModel
  
//  @EnvironmentObject var viewModel: ViewModel
    var body: some View {
      Text("\(post.userID)")
      VStack {
        Text("song is : \(post.song.songName)").font(.title).aspectRatio(contentMode: .fit)
        Text("artist  is : \(post.song.artist)")
        Text("\(post.caption)")
        ForEach(post.moods, id:\.self){ mood in
          roundedRectangleText(bodyText: mood, TextHex: "#000000", BackgroundHex: "#FFFFFF")
        }
      }.fixedSize(horizontal: false, vertical: false)
        .multilineTextAlignment(.center)
        .padding([.top, .bottom], 5)
        .padding([.trailing, .leading], 5)
        .foregroundColor(viewModel.hexStringToUIColor(hex: "#FFFFFF"))
        .background(viewModel.hexStringToUIColor(hex: "#373547"))
        .cornerRadius(8)
      if post.likes.contains(viewModel.user.id) {
        Button {
//          viewModel.unlikePost(post.id, post.likes)
        } label: {
          Image(systemName: "heart.fill")
        }
        
      } else {
        Button {
          viewModel.likePost(docID, post.likes)
        } label: {
          Image(systemName: "heart")
        }
      }
    }
}
