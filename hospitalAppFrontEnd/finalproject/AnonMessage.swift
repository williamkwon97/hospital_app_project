//
//  AnonMessage.swift
//  finalproject
//
//  Created by Peter Vail Driscoll II on 5/15/20.
//  Copyright © 2020 groupproject. All rights reserved.
//

import UIKit
import JSQMessagesViewController

enum AnonMessageStatus {
    case sending
    case delivered
}

class AnonMessage: JSQMessage {
    var status : AnonMessageStatus
    var id : Int

    public init!(senderId: String, status: AnonMessageStatus, displayName: String, text: String, id: Int) {
        self.status = status
        self.id = id
        super.init(senderId: senderId, senderDisplayName: displayName, date: Date.init(), text: text)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
