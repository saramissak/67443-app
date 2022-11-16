//
//  miniUserInfo.swift
//  TuneIn
//
//  Created by The Family on 11/15/22.
//

import SwiftUI

struct miniUserInfo: View {
  var userID: String
  @EnvironmentObject var viewModel: ViewModel
  var body: some View {
    HStack{
      AsyncImage(url: URL(string: viewModel.users[userID]?.profileImage ?? "")) { image in
          image.resizable()
      } placeholder: {
        Image(systemName: "person.circle.fill") .font(.system(size: 35))

      }
      .frame(width: 35, height: 35)
      .clipShape(Circle())
      Text("\(userID)")
        }
      Spacer()
    }
    
  }


