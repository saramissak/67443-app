//
//  PostCard.swift
//  TuneIn
//
//  Created by Sara Missak on 11/4/22.
//

import SwiftUI

struct PostCard: View {
  var post: Post
  @EnvironmentObject var viewModel: ViewModel
  
//  @EnvironmentObject var viewModel: ViewModel
    var body: some View {
//      Text("\(post.song.songName ?? "no song")")
      Text("song is : \(post.song.songName)")
      Text("artist  is : \(post.song.artist)")
      Text("\(post.caption)")
      Text("\(post.userID)")
//      Text("\(post.moods)")
//      Text("song name is \(song.songName)")

      ForEach(post.moods, id:\.self){ mood in
        roundedRectangleText(bodyText: mood, TextHex: "#000000", BackgroundHex: "#FFED95")
      }
    }
}

//struct PostCard_Previews: PreviewProvider {
//    static var previews: some View {
//        PostCard()
//    }
//}
