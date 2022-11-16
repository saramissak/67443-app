//
//  HomeFeed.swift
//  TuneIn
//
//  Created by The Family on 11/3/22.
//

import SwiftUI

struct HomeFeed: View {
  @EnvironmentObject var viewModel: ViewModel
  @State var isNavBarHidden = true
  var body: some View {
    
    NavigationView{
      VStack{
        HStack{
          Spacer()
          NavigationLink(destination: SearchSong(), label: {
            Text("Post a Song of the Day")
            // need to add conditional
              .fontWeight(.bold)
              .font(.body)
          }).navigationBarTitle("")
            .navigationBarHidden(self.isNavBarHidden)
            .onAppear {
              self.isNavBarHidden = true
            }
              
          }
          ScrollView{
            VStack{
              Spacer()
              ForEach(Array(viewModel.posts.keys), id: \.self) { key in
                PostCard(post: viewModel.posts[key]!, docID: key, displayCommentButton: true)
              }
            }
          }
        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        
        
      }
    }
    
    
    
    //    return Text("HELLO \(viewModel.posts.count)")
  }
  
  
  //struct HomeFeed_Previews: PreviewProvider {
  //    static var previews: some View {
  //        HomeFeed(ViewModel())
  //    }
  //}

