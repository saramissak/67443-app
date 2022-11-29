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
  @State var ignoredBanner = false
  var body: some View {
    NavigationView{
      VStack{
        if viewModel.hasPostedSongOfDay() == false && ignoredBanner == false {
          VStack{
            Text("You haven’t posted your song of the day. Would you like to upload now? ")
            HStack{
              NavigationLink(destination: SearchSong(), label: {
                roundedRectangleText(bodyText: "Add Song", TextHex: "#000000", BackgroundHex: "#DECFE4")
              })
              .navigationBarHidden(self.isNavBarHidden)
                .onAppear {
                  self.isNavBarHidden = true
                }
              
              Button("ignore", action:{
                ignoredBanner = true
              })
            }

          }.background(viewModel.hexStringToUIColor(hex: "373547"))
        }
        if viewModel.hasPostedSongOfDay() == false && ignoredBanner == true {
          HStack{
            Spacer()
            NavigationLink(destination: SearchSong(), label: {
              roundedRectangleText(bodyText: "Post Song of the Day", TextHex: "#000000", BackgroundHex: "#DECFE4")
              // need to add conditional
                .fontWeight(.bold)
                .font(.body)
                .padding([.trailing,.leading], 20)
            })
              .navigationBarHidden(self.isNavBarHidden)
              .onAppear {
                self.isNavBarHidden = true
              }
            }
        }

        let sortedByDate = Array(viewModel.posts.keys).sorted{ return viewModel.posts[$0]!.createdAt > viewModel.posts[$1]!.createdAt}
          ScrollView{
            VStack{
              Spacer()
              ForEach(sortedByDate, id: \.self) { key in
                PostCard(post: viewModel.posts[key]!, docID: key, displayCommentButton: true)
              }
            }
          }
        }
//        .navigationBarTitle("")
//        .navigationBarHidden(true)
        
        
      }
    }
    
    
    
    //    return Text("HELLO \(viewModel.posts.count)")
  }
  
  
  //struct HomeFeed_Previews: PreviewProvider {
  //    static var previews: some View {
  //        HomeFeed(ViewModel())
  //    }
  //}

