//
//  StatusPlayersManager.swift
//  GooseGameKata
//
//  Created by Daniele99999999 on 16/06/18.
//  Copyright © 2018 Daniele99999999. All rights reserved.
//

import Foundation

enum Status: String {
    case Off
    case Seek
    case Turn
    case Win
}

protocol StatusProtocol {
    var currentStatus: (status: Status, playerIndex: Int?) {get}
    func isWin() -> Bool
    func isOff() -> Bool
    func isOn() -> Bool
    func isBounced(action: ActionMove) -> Bool
    func maxPositionWhileMove(action: ActionMove) -> Int
    func isRightTurn(_ action: ActionMove) -> Bool
    func canMove(_ action: ActionMove) -> String?
    func updateForWinStatus()
    func updateActionAdd(_ action: ActionAdd) -> String
    func updateActionExit()
    func startGame()
    func nextPlayer()
}

protocol PlayerProtocol {
    var playersArray: [Player] {get}
    func getActivePlayer() -> Player?
    func getPlayerByName(_ name: String) -> Player?
    func isPlayerPresent(_ action: ActionMove) -> Bool
    func isPlayerAlreadyPresent(_ action: ActionAdd) -> Bool
}

protocol StatusPlayerProtocol: StatusProtocol, PlayerProtocol {}

class StatusPlayersManager: StatusPlayerProtocol {
// MARK: Status related
    private(set) var currentStatus: (status: Status, playerIndex: Int?) = (.Seek, nil)
    
    func isWin() -> Bool {
        // controllo se qualcuno ha vinto -> devo terminare l'esecuzione del programma
        
        return (self.currentStatus.status == .Win)
    }
    
    func isOff() -> Bool {
        // controllo se sono in Off -> devo terminare l'esecuzione del programma
        
        return (self.currentStatus.status == .Off)
    }
    
    func isOn() -> Bool {
        // controllo se sono in esecuzione
        
        return !(self.isWin() || self.isOff())
    }
    
    func isBounced(action: ActionMove) -> Bool {
        // controllo se sono rimbalzato
        
        guard let player = self.getPlayerByName(action.player) else {
            // prelevo il player dalla action
            return false
        }
        
        return RulesManager.isBounced(player: player, action: action)
    }
    
    func maxPositionWhileMove(action: ActionMove) -> Int {
        guard let player = self.getPlayerByName(action.player) else {
            // prelevo il player dalla action
            return -1
        }
        
        return RulesManager.maxPositionWhileMove(player: player, action: action)
    }
    
    func isRightTurn(_ action: ActionMove) -> Bool {
        // controllo se il player da muovere è quello del turno attuale
        
        guard let actualPlayer = self.getActivePlayer() else {
            // controllo se c'è un player che deve muovere
            return false
        }
        
        guard let playerToMove = self.getPlayerByName(action.player) else {
            // prelevo il player dalla action
            return false
        }
        
        return actualPlayer == playerToMove
    }
    
    func canMove(_ action: ActionMove) -> String? {
        // controllo se posso far partire una actionMove
        
        if !RulesManager.isPlayable(players: self.playersArray) {
            // controllo se ho il numero di giocatori sufficienti
            return String(format: Constants.Localize.ActionMessage.MoveFewPlayersError, arguments: [self.playersArray.count.string, RulesManager.minNumberOfPlayers().string])
        } else if !self.isPlayerPresent(action) {
            // player che non esiste
            return String(format: Constants.Localize.ActionMessage.MoveExistanceError, action.player)
        } else if !self.isOn() {
            // controllo se posso far partire la partita
            return String(format: Constants.Localize.ActionMessage.MoveIllegalStatusError, action.player)
        }
            
        guard let player = self.getActivePlayer() else {
            if let player = self.playersArray.first {
                if player.name == action.player {
                    // gioco non in fase Turn, ma il action.player è quello che deve partire -> posso muovere
                    
                    // tutto pronto per muovere: faccio partire il gioco, se non lo è già
                    self.startGame()
                    
                    return nil
                } else {
                    // gioco non in fase Turn, e action.player non è quello che deve partire -> non posso muovere
                    return String(format: Constants.Localize.ActionMessage.MoveWrongTurnError, arguments: [action.player, player.name])
                }
            } else {
                // non ci sono giocatori
                return String(format: Constants.Localize.ActionMessage.MoveFewPlayersError, arguments: [self.playersArray.count.string, RulesManager.minNumberOfPlayers().string])
            }
        }
            
        if !self.isRightTurn(action) {
            // non è il mio turno
            return String(format: Constants.Localize.ActionMessage.MoveWrongTurnError, arguments: [action.player, player.name])
        }
        
        // tutto pronto per muovere: faccio partire il gioco, se non lo è già
        self.startGame()
        
        return nil
    }
    
    
// MARK: update Status
    func updateForWinStatus() {
        // controllo che qualche player sia arrivato alla GoalCell
        
        for player in self.playersArray {
            if RulesManager.isWinner(player) {
                self.currentStatus.status = .Win
            }
        }
    }
    
    func updateActionAdd(_ action: ActionAdd) -> String {
        // aggiorno l'array dei giocatori
        
        if (self.currentStatus.status == .Off) || (self.currentStatus.status == .Seek) {
            // aggiorno l'array dei giocatori
            if self.isPlayerAlreadyPresent(action) {
                // player esistente, non posso aggiungere
                return String(format: Constants.Localize.ActionMessage.AddExistanceError, action.player)
            } else {
                // player non esistente, aggiungo
                let player = Player(name: action.player)
                self.playersArray.append(player)
                
                // aggiorno lo stato
                self.currentStatus.status = .Seek
                
                // creo il messaggio di servizio
                var outputMessage = Constants.Localize.ActionMessage.Add1
                
                // ciclo i players e concateno
                var playersArray = [String]()
                for player in self.playersArray {
                    playersArray.append(player.name)
                }
                
                outputMessage += playersArray.joined(separator: Constants.Localize.ActionMessage.AddConnector)
                
                return outputMessage
            }
        } else {
            return String(format: Constants.Localize.ActionMessage.AddIllegalStatusError, action.player)
        }
    }
    
    func updateActionExit() {
        // pulisco gli array di giocatori
        self.playersArray.removeAll()
        
        // aggiorno lo status
        self.currentStatus.status = .Off
        self.currentStatus.playerIndex = nil
    }
    
    func startGame() {
        if (self.currentStatus.status == .Seek) {
            self.currentStatus.status = .Turn
            
            // valorizzo il playerIndex sul primo giocatore
            self.currentStatus.playerIndex = 0
        }
    }
    
    func nextPlayer() {
        // incremento l'indice del turno
        if (self.currentStatus.status == .Turn) {
            // gioco partito
            if let playerIndex = self.currentStatus.playerIndex {
                self.currentStatus.playerIndex? = (playerIndex + 1) % playersArray.count
            }
        }
    }
    
    
// MARK: Players related
    private(set) var playersArray: Array = [Player]() // Player
    
    func getActivePlayer() -> Player? {
        guard let playerIndex = self.currentStatus.playerIndex else {
            return nil
        }
        
        return self.playersArray[playerIndex]
    }
    
    func getPlayerByName(_ name: String) -> Player? {
        return self.playersArray.first { (player) -> Bool in
            player.name == name
        }
    }
    
    func isPlayerPresent(_ action: ActionMove) -> Bool {
        return self.isPlayerAlreadyPresent(ActionAdd(player: action.player))
    }
    
    func isPlayerAlreadyPresent(_ action: ActionAdd) -> Bool {
        if self.playersArray.contains(where: { $0.name == action.player }) {
            // player esistente, non posso aggiungere
            return true
        } else {
            // player non esistente, torno nil
            return false
        }
    }
}
