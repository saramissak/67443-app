//
//  SearchField.swift
//  TuneIn
//
//  Created by The Family on 12/8/22.
//

import SwiftUI

struct SearchField: View {
  @EnvironmentObject var viewModel: ViewModel
  var innerText: String
  var binding: Binding<String>
  
    var body: some View {
      HStack {
        Image(systemName: "magnifyingglass")
            .font(.system(size: 14.0, weight: .bold))
        TextField(innerText, text: binding)
          .autocapitalization(.none)
          .disableAutocorrection(true)
          .fixedSize(horizontal: false, vertical: false)
          .padding([.top, .bottom], 10)
          .padding([.trailing, .leading], 10)
          .foregroundColor(viewModel.hexStringToUIColor(hex: "#FFFFFF"))
          .background(viewModel.hexStringToUIColor(hex: "#373547"))
          .cornerRadius(10)
      }    }
}


