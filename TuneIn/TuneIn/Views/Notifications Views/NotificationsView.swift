//
//  NotificationsView.swift
//  TuneIn
//
//  Created by Luke Arney on 11/7/22.
//

import SwiftUI

struct NotificationsView: View {
  @EnvironmentObject var viewModel: ViewModel
  
  var body: some View {
    
    ScrollView{
      ForEach(viewModel.user.notifications,  id: \.self) { notif in
        NotificationCard(notification: notif)
      }
    }.task{
      viewModel.getNotifications(completionHandler: {_ in})
    }

  }
}

