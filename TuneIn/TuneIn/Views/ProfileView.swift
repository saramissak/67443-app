//
//  ProfileView.swift
//  TuneIn
//
//  Created by Luke Arney on 11/7/22.
//

import SwiftUI
import Spartan

struct ProfileView: View {
  @EnvironmentObject var viewModel: ViewModel
    var body: some View {
      
      Text(viewModel.username)
    }
}

//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}
