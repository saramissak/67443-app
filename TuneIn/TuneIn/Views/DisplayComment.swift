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
    if viewModel.users[comment.userID] != nil {
      print("usercid in displaycomment is: ", comment.userID)
      return HStack{
        Text("\(viewModel.users[comment.userID]!.username): \(comment.text)")
        Spacer()
      }
    } else {
      print("usercid in displaycomment is line 23: ", comment.userID)
      return HStack {
        Text("UserID is: \(comment.userID): \(comment.text)")
        Spacer()
      }
    }
  }
}

