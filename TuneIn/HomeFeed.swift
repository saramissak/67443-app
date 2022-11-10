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
    
    return NavigationView{
      ScrollView{
        VStack{
          Header()
          NavigationLink(destination: SearchSong(), label: {
            Text("Post a Song of the Day")
            // need to add conditional
              .fontWeight(.bold)
              .font(.body)
          }).navigationBarBackButtonHidden(true)

          Spacer()
          ForEach(Array(viewModel.posts.keys), id: \.self) { key in
            PostCard(post: viewModel.posts[key]!, docID: key)
          }
        }
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
