//
//  HomeFeed.swift
//  TuneIn
//
//  Created by The Family on 11/3/22.
//

import SwiftUI

struct HomeFeed: View {
  @ObservedObject var viewModel: ViewModel
  
  var body: some View {
    VStack {
      ForEach(viewModel.posts) { post in
        PostCard(post: post)
        
      }
    }
    
    
//    return Text("HELLO \(viewModel.posts.count)")
    }
}

//struct HomeFeed_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeFeed(ViewModel())
//    }
//}
