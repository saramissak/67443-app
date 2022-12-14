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
        HStack{
          Text(song.songName).font(.headline)
          Spacer()
          Text(song.artist)
        }
      }
    }
}
