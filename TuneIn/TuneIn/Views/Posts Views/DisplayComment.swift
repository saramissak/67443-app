//
//  DisplayComment.swift
//  TuneIn
//
//  Created by Sara Missak on 11/10/22.
//

import SwiftUI

struct DisplayComment: View {
  var post: Post
  var comment: Comment
  
  @EnvironmentObject var viewModel: ViewModel
  var body: some View {
    VStack{
      HStack{
        miniUserInfo(userID:comment.userID).environmentObject(viewModel)
      }
      HStack {
        Text("\(comment.text)")
        Spacer()
      }
    }.padding(10)
      .border(.white,width:0.3)
      .padding([.trailing,.leading],10)

  }
}

