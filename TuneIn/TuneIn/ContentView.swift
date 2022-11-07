//
//  ContentView.swift
//  TuneIn
//
//  Created by Sara Missak on 10/14/22.
//

import SwiftUI

struct ContentView: View {
  @ObservedObject var viewModel = ViewModel()
  @State var received = false
    var body: some View {
//      DispatchQueue.main.async {
//        viewModel.getPosts()
//      }
        if received == false {
        viewModel.getPosts()
        received = true
      }

        
      return HomeFeed(viewModel: viewModel)
                    
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
