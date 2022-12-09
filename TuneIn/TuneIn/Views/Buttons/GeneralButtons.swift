//
//  GeneralButtons.swift
//  TuneIn
//
//  Created by The Family on 12/8/22.
//

import SwiftUI

struct roundedRectangleText : View {
  @EnvironmentObject var viewModel: ViewModel
  var bodyText: String
  var TextHex: String
  var BackgroundHex: String
  var alignment: TextAlignment? = .center
  var topBottomPadding: CGFloat? = 5
  var leftRightPadding: CGFloat? = 20
  var body: some View {
    Text(bodyText)
        .fixedSize(horizontal: false, vertical: true)
        .multilineTextAlignment(alignment ?? .center)
        .padding([.top, .bottom], topBottomPadding)
        .padding([.trailing, .leading], leftRightPadding)
        .foregroundColor(viewModel.hexStringToUIColor(hex: TextHex))
        .background(viewModel.hexStringToUIColor(hex: BackgroundHex))
        .cornerRadius(8)
  }
}



