//
//  PostCard.swift
//  TuneIn
//
//  Created by Sara Missak on 11/4/22.
//

import SwiftUI

struct PostCard: View {
  var post: Post
    var body: some View {
      Text("\(post.song.songName ?? "no song")")
      Text("\(post.caption)")
      Text("\(post.userID)")
//      Text("\(post.moods)")
      ForEach(post.moods, id:\.self){ mood in
        roundedRectangleText(bodyText: mood, TextHex: "#000000", BackgroundHex: "#B9C0FF")
      }
    }
}

//struct PostCard_Previews: PreviewProvider {
//    static var previews: some View {
//        PostCard()
//    }
//}
