//
//  SetBioView.swift
//  TuneIn
//
//  Created by Sara Missak on 11/9/22.
//

import SwiftUI

struct SetBioView: View {
  @EnvironmentObject var viewModel: ViewModel
  @State var changeBio : Bool = false
  @State var searchField: String = ""
  
  var body: some View {
    let binding = Binding<String>(get: {
      self.searchField
    }, set: {
      self.searchField = $0
    })
    
    TextField("Search", text: binding)
    
    NavigationView {
      NavigationLink(destination: SetBioView().environmentObject(viewModel), isActive: $changeBio) {
          Text("Set Bio")
            .fontWeight(.bold)
            .font(.body)
        }
        .onChange(of: changeBio) { (newValue) in
          viewModel.setBio(self.searchField)
          ProfileView().environmentObject(viewModel)
        }
        .navigationBarBackButtonHidden(true)
      }
    }
}

//struct SetBioView_Previews: PreviewProvider {
//    static var previews: some View {
//        SetBioView()
//    }
//}
