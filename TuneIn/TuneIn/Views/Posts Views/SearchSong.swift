//
//  SearchSong.swift
//  TuneIn
//
//  Created by The Family on 11/9/22.
//

import SwiftUI
import Spartan

struct SearchSong: View {
  @EnvironmentObject var viewModel: ViewModel
  @State var searchField: String = ""
  @State var displaySongs = [SimplifiedTrack]()
  var body: some View {
    let binding = Binding<String>(get: {
      self.searchField
    }, set: {
      self.searchField = $0
      self.viewModel.searchSong( self.searchField, completionHandler: { _ in})
      //         viewModel.displayDefaultSongs()
    })
    
    VStack{
      Text("select a song")
      SearchField(innerText: "search a song", binding: binding)
          
      List(viewModel.searchedSongs){ song in
        NavigationLink(destination: PostSongView(song:song)){
          SongRow(song:song)
        }
      }
    }
  }
}
  
