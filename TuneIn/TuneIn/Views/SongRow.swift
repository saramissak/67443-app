//
//  SongRow.swift
//  TuneIn
//
//  Created by The Family on 11/9/22.
//

import SwiftUI

struct SongRow: View {
  var song:Song
    var body: some View {
      VStack{
        Text(song.songName).font(.headline)
      }
      
    }
}

//struct SongRow_Previews: PreviewProvider {
//    static var previews: some View {
//        SongRow()
//    }
//}
