//
//  PostSongView.swift
//  TuneIn
//
//  Created by The Family on 11/9/22.
//

import SwiftUI
import WrappingStack

struct PostSongView: View {
  @EnvironmentObject var viewModel: ViewModel
  @State private var caption: String = ""
  @State private var mood: String = ""
  @State var moodInput: String = ""
  @State var madePost : Bool = false
  @State var albumImage = UIImage()
  @State var moodList = [String]()
  
  var song: Song
  var response: String = ""
  var body: some View {
  
  let binding = Binding<String>(get: {
    self.moodInput
  }, set: {
    self.moodInput = $0
  })
    ScrollView{

    VStack{
      HStack{
        Image(uiImage: albumImage)
          .resizable()
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
      
      TextField("caption", text:$caption)
        .frame(height:200)
        .border(.white, width: 1)
      
      Text("Moods").font(.title2).fontWeight(.bold)
        .fixedSize(horizontal: false, vertical: true)
      WrappingHStack(id: \.self, alignment: .leading){
        ForEach(self.moodList, id: \.self) { mood in
          roundedRectangleText(bodyText: mood, TextHex: "#000000", BackgroundHex: "#FFED95")    .padding(2)
        }
      }

      
      HStack{
        TextField("Mood", text: $moodInput)
        Button("Add", action:{
          self.moodList.append(self.moodInput)
          self.moodInput = ""
        })
      }

      
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
        viewModel.makePost(song:song, caption:caption, moods: self.moodList)
        HomeFeed().environmentObject(viewModel).navigationBarBackButtonHidden(true)
      }
    }
     .navigationBarBackButtonHidden(false)
    }
  }
  
}
