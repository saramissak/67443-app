//
//  CommentScreen.swift
//  TuneIn
//
//  Created by Sara Missak on 11/10/22.
//

import SwiftUI

struct CommentScreen: View {
  var post: Post
  var docID: String
  @State var commentString: String = ""
  @EnvironmentObject var viewModel: ViewModel
  
  var body: some View {
    let binding = Binding<String>(get: {
      self.commentString
    }, set: {
      self.commentString = $0
    })
    
    VStack{
      PostCard(post: post, docID: docID, displayCommentButton: false).environmentObject(viewModel)//      FullPostView(post:post, docID:docID)
      Spacer()
      ForEach(viewModel.comments) { comment in
        DisplayComment(post: post, comment: comment).environmentObject(viewModel)
      }
      Spacer()
      
      HStack{
        TextField("Comment here", text:binding)
        Button("Post", action: {
          viewModel.postComment(docID: docID, comment: self.commentString, post: post)
          self.commentString = ""
         })
      }.padding([.top,.bottom],10)
        .padding([.trailing,.leading],10)
    }
  }
}
