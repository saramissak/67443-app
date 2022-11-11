//
//  SetBioView.swift
//  TuneIn
//
//  Created by Sara Missak on 11/9/22.
//

import SwiftUI
import UIKit

struct SetBioView: View {
  @EnvironmentObject var viewModel: ViewModel
  var user: UserInfo
  @State var changeBio : Bool = false
  @State var searchField: String = ""
  @State private var name: String = ""
  @State private var username: String = ""
  @State private var bio: String = ""
  @State private var genres: String = ""
  
  private func editButton(action: @escaping () -> Void) -> some View {
    Button(action: { action() }){
      Text("Done")
    }
  }
  
  var body: some View {
    NavigationView {
//    let binding = Binding<String>(get: {
//      self.searchField
//    }, set: {
//      self.searchField = $0
//    })
    
    //TextField("Search", text: binding)
      Form {
        Section(header: Text("Peronal")){
          TextField("Name", text: $name)
          TextField("Username", text: $username)
        }
        Section(){
          TextField("Bio", text: $bio)
        }
        Section(){
          TextField("Favorite Genre", text: $genres)
        }
        Button("Save Changes", action: {}
        )
        .onTapGesture {
          print("Button tapped, \(self.bio)")
          viewModel.setBio(self.bio)
        }
      }
    }
    .navigationTitle("Edit Account")
    .onTapGesture {
      hideKeyboard()
    }
    }
}
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

//struct SetBioView_Previews: PreviewProvider {
//    static var previews: some View {
//        SetBioView()
//    }
//}
