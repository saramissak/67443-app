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
  @FocusState private var isFocused: Bool
  
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
      
      TextField("caption...", text:$caption)
        .frame( height: 50)
        .padding(EdgeInsets(top: 0, leading: 6, bottom: 30, trailing: 6))
        .border(.white, width: 0.5)
        .focused($isFocused)
        .onTapGesture {
            isFocused = true
        }
      
      Spacer()
      Text("Moods").font(.title2).fontWeight(.bold)
        .fixedSize(horizontal: false, vertical: true)
      WrappingHStack(id: \.self, alignment: .leading){
        ForEach(self.moodList, id: \.self) { mood in
          Button(action: {removeMoodFromList(mood)}, label: {EditableMoodButton(bodyText:  mood, TextHex: "#000000", BackgroundHex: "#FFED95")})

        }
      }

      
      HStack{
        TextField("Mood", text: $moodInput)
        Button("Add", action:{
          if self.moodInput.trimmingCharacters(in: .whitespacesAndNewlines) != ""{
            self.moodList.append(self.moodInput)
            self.moodInput = ""
          }

        }).foregroundColor(.white)
      }

      
      // entering moods
      
      NavigationLink(destination: HomeFeed().environmentObject(viewModel), isActive: $madePost, label: {
        Text("Post")
          .fontWeight(.bold)
          .font(.title).contentShape(Rectangle())
          .background(viewModel.hexStringToUIColor(hex: "#FFED95"))
          .foregroundColor(viewModel.hexStringToUIColor(hex: "#000000"))
          .cornerRadius(8)
          .padding(40)
//          .frame(width: 30, height: 30)
      })
      .onChange(of: madePost) { (newValue) in
        viewModel.makePost(song:song, caption:caption, moods: self.moodList)
        HomeFeed().environmentObject(viewModel)

      }
    }
     .navigationBarBackButtonHidden(false)
     .padding([.trailing, .leading], 10)

    }
  }
  func removeMoodFromList( _ mood: String) -> Void{
    let newList = self.moodList.filter{$0 != mood}
    self.moodList = newList
  }
  
}


