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
      self.viewModel.searchSong( self.searchField)
      //         viewModel.displayDefaultSongs()
    })
    return NavigationView{
      VStack{
        Text("select a song")
        TextField("Search", text:binding)
        
        List(viewModel.searchedSongs){ song in
          NavigationLink(destination: PostSongView(song:song)){
            SongRow(song:song)
          }
          
        }
        
      }
      
      //      ForEach(displayedSongs, id: \.self) {
      
      
    }
    
    
    
  }
}
  


//struct SearchSong_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchSong()
//    }
//}
