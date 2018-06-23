//
//  ActionAdd.swift
//  GooseGameKata
//
//  Created by Daniele99999999 on 17/06/18.
//  Copyright © 2018 Daniele99999999. All rights reserved.
//

import Foundation

class ActionAdd: Action, Codable, CustomStringConvertible {
    var type: ActionType
    var player: String
    
    init(player: String) {
        self.type = .Add
        self.player = player
    }
}
