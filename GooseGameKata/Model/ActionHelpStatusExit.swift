//
//  ActionHelpStatusExit.swift
//  GooseGameKata
//
//  Created by Daniele99999999 on 17/06/18.
//  Copyright © 2018 Daniele99999999. All rights reserved.
//

import Foundation

class ActionHelpStatusExit: Action, Codable, CustomStringConvertible {
    var type: ActionType
    
    private init(type: ActionType) {
        self.type = type
    }
    
    class func actionHelp() -> ActionHelpStatusExit {
        return ActionHelpStatusExit(type: .Help)
    }
    
    class func actionStatus() -> ActionHelpStatusExit {
        return ActionHelpStatusExit(type: .Status)
    }
    
    class func actionExit() -> ActionHelpStatusExit {
        return ActionHelpStatusExit(type: .Exit)
    }
}
