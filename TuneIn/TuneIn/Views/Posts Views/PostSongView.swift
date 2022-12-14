//
//  PostSongView.swift
//  TuneIn
//
//  Created by The Family on 11/9/22.
//

import SwiftUI
import WrappingStack
import Combine
import SpotifyWebAPI


struct PostSongView: View {
  @EnvironmentObject var viewModel: ViewModel
  @State private var caption: String = ""
  @State private var mood: String = ""
  @State var moodInput: String = ""
  @State var madePost : Bool = false
  @State var albumImage = UIImage()
  @State var moodList = [String]()
  @FocusState private var isFocused: Bool
  
  @State private var playTrackCancellable: AnyCancellable? = nil
  static let spotify = Spotify()
  
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
        self.albumImageWithPlayButton
        VStack{
          Text("\(song.songName)").font(.body).fontWeight(.bold).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
          Text("By: \(song.artist)").font(.body).fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity, alignment: .leading)
        }.padding([.top,.bottom],10)
      }
      
      TextField("caption...", text:$caption, axis: .vertical)
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
        Image(uiImage: viewModel.postButton)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 100)
          .clipped()
          .padding()
      })
      .onChange(of: madePost) { (newValue) in
        viewModel.makePost(song:song, caption:caption, moods: self.moodList)
        HomeFeed().environmentObject(viewModel)

      }
    }
     .navigationBarBackButtonHidden(false)
     .padding([.trailing, .leading], 10)

    }
    .onTapGesture {
      hideKeyboardPostSongView()
    }
  }
    
  func removeMoodFromList( _ mood: String) -> Void{
    let newList = self.moodList.filter{$0 != mood}
    self.moodList = newList
  }
  var albumImageWithPlayButton: some View {
      ZStack {
        Image(uiImage: albumImage)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 200, height: 200)
          .clipped()
          .contentShape(Rectangle())
          .task {
            do{
              print("SONG HERE", song)
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

          Button(action: playTrack, label: {
              Image(systemName: "play.circle")
                  .resizable()
                  .background(Color.black.opacity(0.5))
                  .clipShape(Circle())
                  .frame(width: 100, height: 100)
                  .foregroundColor(.white)
          })
      }
  }
  
  func playTrack() {
    //viewModel.updateSongPost(currPost: self.post)
    let track = song
    let alertTitle = "Couldn't play \(track.songName)"

    let trackURI = track.previewURL
    
    let playbackRequest: PlaybackRequest
    
    if let albumURI = track.albumURI {
        // Play the track in the context of its album. Always prefer
        // providing a context; otherwise, the back and forwards buttons may
        // not work.
        playbackRequest = PlaybackRequest(
            context: .contextURI(albumURI),
            offset: .uri(trackURI!)
        )
    }
    else {
      playbackRequest = PlaybackRequest(trackURI!)
    }

    self.playTrackCancellable = PostCard.spotify.api
        .getAvailableDeviceThenPlay(playbackRequest)
        .receive(on: RunLoop.main)
        .sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                AlertItem(
                    title: alertTitle,
                    message: error.localizedDescription
                )
                print("\(alertTitle): \(error)")
            }
        })
    
}
}
#if canImport(UIKit)
extension View {
    func hideKeyboardPostSongView() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif


