//
//  RulesManager.swift
//  GooseGameKata
//
//  Created by Daniele99999999 on 16/06/18.
//  Copyright © 2018 Daniele99999999. All rights reserved.
//

import Foundation

struct Configuration: Codable, CustomStringConvertible {
    var GooseCells = [5, 9, 14, 18, 23, 27]
    var BridgeCells = [6]
    var MultiplePlayerCells = [0]
    var GoalCell = 63
    var MinNumberOfPlayers = 2
    var Prank = true
}

class RulesManager {
    static var configuration = Configuration()
    
// MARK: helper Action
    class func rollDice() -> Int {
        return Int.random(between: 1, and: 6)
    }
    
    class func validPlayerName(_ input: String) -> Bool {
        return (input.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil)
    }
    
    class func validDice1(_ input: String) -> Bool {
        return input.matches(pattern: "^[1-6],") && input.count == 2
    }
    
    class func validDice2(_ input: String) -> Bool {
        return input.matches(pattern: "^[1-6]") && input.count == 1
    }
    
    class func cleanDice(_ input: String) -> Int? {
        return input.replacingOccurrences(of: ",", with: "").int
    }
    
    class func cleanMoveTo(position: Int) -> Int {
        let positivePosition = max(0, position)
        return min(positivePosition, self.configuration.GoalCell) + min(0, self.configuration.GoalCell - positivePosition)
    }
    

// MARK: check Special position
    class func isOnGoose(_ player: Player) -> Bool {
        return self.isOnGoose(player.actualPosition)
    }
    
    class func isOnGoose(_ position: Int) -> Bool {
        return self.configuration.GooseCells.contains(position)
    }
    
    class func isOnBridge(_ player: Player) -> Bool {
        return self.isOnBridge(player.actualPosition)
    }
    
    class func isOnBridge(_ position: Int) -> Bool {
        return self.configuration.BridgeCells.contains(position)
    }
    
    class func isOnMultiplePlayerCells(_ player: Player) -> Bool {
        return self.isOnMultiplePlayerCells(player.actualPosition)
    }
    
    class func isOnMultiplePlayerCells(_ position: Int) -> Bool {
        return self.configuration.MultiplePlayerCells.contains(position)
    }
    
    class func isOnPlayers(player: Player, players: [Player]) -> Player? {
        // controllo se sono sopra un altro player: nel caso, ritorno il player sotto
        
        var playerOver: Player? = nil
        if RulesManager.isPrankActive() || !RulesManager.isOnMultiplePlayerCells(player) {
            for playerToCheck in players {
                if player.name != playerToCheck.name && player.isOver(player: playerToCheck) {
                    playerOver = playerToCheck
                    break
                }
            }
        }
        
        return playerOver
    }
    
    class func isBounced(player: Player, action: ActionMove) -> Bool {
        return (player.previousPosition + action.dice1 + action.dice2 > self.configuration.GoalCell)
    }
    
    class func maxPositionWhileMove(player: Player, action: ActionMove) -> Int {
        return min(player.previousPosition + action.dice1 + action.dice2, self.configuration.GoalCell)
    }
    
    
// MARK: misc
    class func isPrankActive() -> Bool {
        return self.configuration.Prank
    }
    
    class func isWinner(_ player: Player) -> Bool {
        return player.actualPosition == self.configuration.GoalCell
    }
    
    class func minNumberOfPlayers() -> Int {
        return self.configuration.MinNumberOfPlayers
    }
    
    class func isPlayable(players: [Player]) -> Bool {
        return players.count >= RulesManager.minNumberOfPlayers()
    }
}
