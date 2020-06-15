//
//  Message.swift
//  iChat
//
//  Created by Ahmed on 6/15/20.
//  Copyright © 2020 Ahmed,ORG. All rights reserved.
//

import Foundation
import MessageKit

struct Message: MessageType {
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
    
    
}
