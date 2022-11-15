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
      Image(uiImage: albumImage)
        .aspectRatio(contentMode: .fit)
        .frame(width: 100, height: 100)
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
      Text("\(song.songName)")
      Text("\(song.artist)")
      TextField("caption", text: $caption)
      Text("Moods")
      // entering moods
      NavigationLink(destination: HomeFeed().environmentObject(viewModel), isActive: $madePost, label: {
        Text("Post")
        // need to add conditional
          .fontWeight(.bold)
          .font(.body)
      })
      .onChange(of: madePost) { (newValue) in
        viewModel.makePost(song:song, caption:caption)
        HomeFeed().environmentObject(viewModel)
      }
      .navigationBarBackButtonHidden(false)

    }.navigationBarTitle("")
     .navigationBarHidden(true)
  }
  
}
