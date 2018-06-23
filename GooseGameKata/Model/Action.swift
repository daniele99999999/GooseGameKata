//
//  Action.swift
//  GooseGameKata
//
//  Created by Daniele99999999 on 16/06/18.
//  Copyright © 2018 Daniele99999999. All rights reserved.
//

import Foundation

enum ActionType: String, Codable {
    case Help
    case Add
    case Move
    case MoveSpecial
    case Status
    case Exit
}

protocol Action: Codable {
    var type: ActionType {get}
}
