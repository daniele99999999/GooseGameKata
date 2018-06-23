//
//  Player.swift
//  GooseGameKata
//
//  Created by Daniele99999999 on 16/06/18.
//  Copyright © 2018 Daniele99999999. All rights reserved.
//

import Foundation

class Player: Equatable, CustomStringConvertible {
    var name: String
    
    private (set) var previousPosition: Int = 0
    private (set) var actualPosition: Int = 0
    
    init(name: String) {
        self.name = name
    }
    
    static func == (lhs: Player, rhs: Player) -> Bool {
        return lhs.name == rhs.name
    }
    
    func move(action: ActionMove) {
        self.move(dice1: action.dice1, dice2: action.dice2)
    }
    
    private func move(dice1: Int, dice2: Int) {
        self.moveTo(position: self.actualPosition + dice1 + dice2)
    }
    
    private func moveTo(position: Int) {
        self.previousPosition = self.actualPosition
        self.actualPosition = RulesManager.cleanMoveTo(position: position)
    }
    
    func isOver(player: Player) -> Bool {
        return self.actualPosition == player.actualPosition
    }
}
