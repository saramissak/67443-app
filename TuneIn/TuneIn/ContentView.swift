//
//  ContentView.swift
//  TuneIn
//
//  Created by Sara Missak on 10/14/22.
//

import SwiftUI

struct ContentView: View {
  var viewModel: ViewModel = ViewModel()
    
    var body: some View {
//      DispatchQueue.main.async {
//        viewModel.getPosts()
//      }
      viewModel.getPosts()
        
      return HomeFeed(viewModel: viewModel)
                    
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
