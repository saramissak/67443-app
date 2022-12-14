//
//  MoodButtons.swift
//  TuneIn
//
//  Created by The Family on 12/8/22.
//

import SwiftUI

struct EditableMoodButton: View {
  @EnvironmentObject var viewModel: ViewModel
  var bodyText: String
  var TextHex: String
  var BackgroundHex: String
    var body: some View {
      HStack{
        Text(bodyText)

        Image(systemName: "xmark")
      } .fixedSize(horizontal: false, vertical: true)
        .multilineTextAlignment( .center)
        .padding([.top, .bottom], 5)
        .padding([.trailing, .leading], 20)
        .foregroundColor(viewModel.hexStringToUIColor(hex: TextHex))
        .background(viewModel.hexStringToUIColor(hex: BackgroundHex))
        .cornerRadius(8)
        .padding(2)
    }
}

