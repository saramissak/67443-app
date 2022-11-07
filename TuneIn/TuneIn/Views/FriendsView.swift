//
//  FriendsView.swift
//  TuneIn
//
//  Created by Luke Arney on 11/7/22.
//

import SwiftUI

struct FriendsView: View {
  @ObservedObject var viewModel: ViewModel
  @State private var findTab: Bool = true
  
  var body: some View {
    VStack {
      Text("Tune In").font(.title)
      HStack {
        Spacer()
        Button("find", action:{
          self.findTab = true
        }).background( Color.black )
          .foregroundColor(.white)
          .cornerRadius(6)
          
        
        Spacer()
        
        Button("friends", action:{
          self.findTab = false
        }).background( Color.black )
          .foregroundColor(.white)
          .cornerRadius(6)
        Spacer()
      }
      Spacer()
      if self.findTab {
        SearchBar(viewModel: viewModel) // finds people
      } else {
        SearchFriends(viewModel: viewModel)
      }
    }
    
    
  }
}

struct FriendsView_Previews: PreviewProvider {
    static var previews: some View {
      FriendsView(viewModel: ViewModel())
    }
}
