//
//  NotificationCard.swift
//  TuneIn
//
//  Created by The Family on 12/1/22.
//

import SwiftUI

struct NotificationCard: View {
  var notification: Notification
    var body: some View {
      Text(notification.userID)
      Text(notification.otherUser)
    }
}


