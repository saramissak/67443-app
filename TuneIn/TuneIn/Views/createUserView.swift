//
//  createUserView.swift
//  TuneIn
//
//  Created by The Family on 11/10/22.
//

import SwiftUI

struct createUserView: View {
  @ObservedObject var viewModel: ViewModel
    var body: some View {
      Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
      Button("Login with Spotify Credentials", action:{
        viewModel.login()
      })
    }
}

