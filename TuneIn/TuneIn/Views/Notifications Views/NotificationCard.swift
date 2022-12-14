//
//  NotificationCard.swift
//  TuneIn
//
//  Created by The Family on 12/1/22.
//

import SwiftUI

struct NotificationCard: View {
  
  var notification: Notification
  @EnvironmentObject var viewModel: ViewModel
  @State var notifText = ""
    var body: some View {
      HStack{
        AsyncImage(url: URL(string: viewModel.users[notification.otherUser]?.profileImage ?? "")) { image in
          image.resizable()
        } placeholder: {
          Image(systemName: "person.circle.fill") .font(.system(size: 35))
        }
        .frame(width: 35, height: 35)
        .clipShape(Circle())
        
        if notification.type == "like" {
          Text("**\(notification.otherUser)** liked your post")
        } else if notification.type == "comment"{
          HStack{
            Text("**\(notification.otherUser)** \(notifText)").fixedSize(horizontal: false, vertical: true)
          }.task{
            viewModel.getCommentByCommentID(notification.commentID) { (comment) in
              notifText = " commented: \(comment)"
            }
          }
        } else if notification.type == "friend request"{
          Text("**\(notification.otherUser)** friend requested you")
        } else if notification.type == "friend added" {
          Text("**\(notification.otherUser)** is now your friend")
        }
        Spacer()
      }
    }
}


