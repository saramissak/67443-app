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
  
  var song: Song
  var body: some View {
    VStack{
      Text("\(song.songName)")
      Text("\(song.artist)")
      TextField("caption", text: $caption)
      Text("Moods")
      // entering moods
      Button("Post", action: {
        viewModel.makePost(song:song, caption:caption)
        self.madePost = true
        
      })
      .alert(isPresented: $madePost) {
        Alert(title: Text("You've posted"), dismissButton: .default(Text("")))      }
    }
  }
  
  //struct PostSongView_Previews: PreviewProvider {
  //    static var previews: some View {
  //        PostSongView()
  //    }
  //}
}
