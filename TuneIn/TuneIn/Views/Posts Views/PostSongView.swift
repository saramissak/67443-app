//
//  PostSongView.swift
//  TuneIn
//
//  Created by The Family on 11/9/22.
//

import SwiftUI

struct PostSongView: View {
  @EnvironmentObject var viewModel: ViewModel
  @State private var caption: String = ""
  @State private var mood: String = ""
  @State var searchField: String = ""
  @State var madePost : Bool = false
  @State var albumImage = UIImage()

  var song: Song
  var response: String = ""
  var body: some View {
    
    VStack{
      HStack{
        Image(uiImage: albumImage)
          .aspectRatio(contentMode: .fit)
          .frame(width: 200, height: 200)
          .clipped()
          .contentShape(Rectangle())
          .task {
            do{
              let response = try await viewModel.getAlbumURLById(for: song.id)
              let url = URL(string: response)
              let data = try? Data(contentsOf:url ?? URL(fileURLWithPath: ""))
              if let imageData = data {
                self.albumImage = UIImage(data: imageData)!
              }
            } catch{
              Text("error")
            }

          }
        VStack{
          Text("\(song.songName)").font(.body).fontWeight(.bold).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
          Text("By: \(song.artist)").font(.body).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
        }.padding([.top,.bottom],10)
      }
      TextField("caption", text:$caption).frame(height:200).border(.white,width: 1)
      Text("Moods").font(.title2).fontWeight(.bold)
        .fixedSize(horizontal: false, vertical: true)
      // entering moods
      NavigationLink(destination: HomeFeed().environmentObject(viewModel), isActive: $madePost, label: {
        Text("Post")
        // need to add conditional
          .fontWeight(.bold)
          .font(.title).contentShape(Rectangle())        .background(viewModel.hexStringToUIColor(hex: "#FFED95"))
          .foregroundColor(viewModel.hexStringToUIColor(hex: "#000000"))
          .cornerRadius(8)
          .padding()
      })
      .onChange(of: madePost) { (newValue) in
        viewModel.makePost(song:song, caption:caption)
        HomeFeed().environmentObject(viewModel)
      }


    }
     .navigationBarBackButtonHidden(false)
  }
  
}
