//
//  HomeFeed.swift
//  TuneIn
//
//  Created by The Family on 11/3/22.
//

import SwiftUI

struct HomeFeed: View {
  @EnvironmentObject var viewModel: ViewModel
  var body: some View {
    //    VStack {
    //      ForEach(viewModel.posts) { post in
    //        DispatchQueue.main.async {
    //          let songObj = viewModel.getSong(post.songID)
    //          PostCard(post: post, song: songObj)
    //        }
    //        }
    //
    //
    //
    //
    ////        viewModel.getSong(post.songID)
    //      }
    VStack{
      ForEach(viewModel.posts){ post in
          PostCard(post:post)
        
      }
    }

  }
    
    
//    return Text("HELLO \(viewModel.posts.count)")
}


//struct HomeFeed_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeFeed(ViewModel())
//    }
//}
