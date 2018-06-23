//
//  ActionMove.swift
//  GooseGameKata
//
//  Created by Daniele99999999 on 17/06/18.
//  Copyright © 2018 Daniele99999999. All rights reserved.
//

import Foundation

class ActionMove: Action, Move, Codable, CustomStringConvertible {
    var type: ActionType
    var moveType: MoveType
    var player: String
    var dice1: Int
    var dice2: Int
    
    private init(player: String, dice1: Int, dice2: Int) {
        self.type = .Move
        self.moveType = .Standard
        self.player = player
        self.dice1 = dice1
        self.dice2 = dice2
    }
    
    private init(moveType: MoveType, player: String, dice: Int) {
        self.type = .MoveSpecial
        self.moveType = moveType
        self.player = player
        self.dice1 = dice
        self.dice2 = 0
    }
    
    class func actionMoveStandard(player: String, dice1: Int, dice2: Int) -> ActionMove {
        return ActionMove(player: player, dice1: dice1, dice2: dice2)
    }
    
    class func actionMoveGoose(player: String, dice: Int) -> ActionMove {
        return ActionMove(moveType: .Goose, player: player, dice: dice)
    }
    
    class func actionMoveBridge(player: String, dice: Int) -> ActionMove {
        return ActionMove(moveType: .Bridge, player: player, dice: dice)
    }
    
    class func actionMoveSwap(player: String, dice: Int) -> ActionMove {
        return ActionMove(moveType: .Swap, player: player, dice: dice)
    }
}
