//
//  ActionManager.swift
//  GooseGameKata
//
//  Created by Daniele99999999 on 16/06/18.
//  Copyright © 2018 Daniele99999999. All rights reserved.
//

import Foundation
import SwifterSwift

protocol ActionsProtocol {
    func manageAction(_ action: Action) -> String
}

class ActionManager: ActionsProtocol {
    private var actionsQueue: Array = [Action]() // coda di azioni
    
    private var statusPlayersManager: StatusPlayerProtocol
    
    init(statusPlayersManager: StatusPlayerProtocol) {
        self.statusPlayersManager = statusPlayersManager
    }
    
    
// MARK: manage
    func manageAction(_ action: Action) -> String {
        // aggiungo la action alla coda
        self.actionsQueue.append(action)
        
        // elaboro le action in coda
        let outputMessage = self.manageActionQueue()

        // ritorno l'output da stampare
        return outputMessage
    }
    
    private func manageActionQueue() -> String {
        var auxiliaryMessage: String? = nil
        var outputSuccessMessage: String = ""

        while self.actionsQueue.count > 0 {
            // prendo la prima action
            let action = self.actionsQueue.removeFirst()
            
            // eseguo i comandi non di movimento
            auxiliaryMessage = self.performAuxiliaryAction(action)
            if (auxiliaryMessage != nil) {continue}
            
            // preparo prima di eseguire i movimenti normali
            auxiliaryMessage = self.preMovementAction(action)
            if (auxiliaryMessage != nil) {continue}
            
            // eseguo i movimenti e creo le azioni speciali
            let specialAction = self.performMovementAction(action)
            
            // controllo se ha vinto qualcuno
            self.statusPlayersManager.updateForWinStatus()
            
            // creo i messaggi dei movimenti
            outputSuccessMessage += self.movementMessage(action: action)
            
            // aggiorno il sistema
            self.postMovementAction(action)
            
            // aggiungo le specialAction alla coda
            self.actionsQueue.append(contentsOf: specialAction)
        }
        
        return auxiliaryMessage ?? outputSuccessMessage
    }

    
// MARK: perform auxiliary
    private func performAuxiliaryAction(_ action: Action) -> String? {
        var outputMessage: String? = nil
        
        switch action.type {
            case .Help:
                outputMessage = self.performAuxiliaryHelp()
            case .Add:
                outputMessage = self.performAuxiliaryAdd(action as! ActionAdd)
            case .Status:
                outputMessage = self.performAuxiliaryStatus()
            case .Exit:
                outputMessage = self.performAuxiliaryExit()
            default:
                break
        }
        
        return outputMessage
    }
    
    private func performAuxiliaryHelp() -> String {
        let outputMessage =
        """
        \(Constants.Localize.ActionMessage.Help0)
        \(Constants.Localize.ActionMessage.Help1)
        \(Constants.Localize.ActionMessage.Help2)
        \(Constants.Localize.ActionMessage.Help3)
        \(Constants.Localize.ActionMessage.Help4)
        \(Constants.Localize.ActionMessage.Help5)
        \(Constants.Localize.ActionMessage.Help6)
        \(Constants.Localize.ActionMessage.Help7)
        \(Constants.Localize.ActionMessage.Help8)
        """
        return outputMessage
    }
    
    private func performAuxiliaryAdd(_ action: ActionAdd) -> String {
        // aggiorno l'array dei giocatori
        return self.statusPlayersManager.updateActionAdd(action);
    }
    
    private func performAuxiliaryStatus() -> String {
        // metto il messaggio iniziale
        var outputMessage = Constants.Localize.ActionMessage.Status1
        
        // ciclo i players e concateno
        var playersStatusArray = [String]()
        if self.statusPlayersManager.playersArray.count > 0 {
            for player in self.statusPlayersManager.playersArray {
                playersStatusArray.append(String(format: Constants.Localize.ActionMessage.Statusn, arguments: [player.name, player.actualPosition.string]))
            }
            
            if self.statusPlayersManager.isWin() {
                // se qualcuno ha vinto, lo aggiungo qui...
                if let player = self.statusPlayersManager.getActivePlayer() {
                    playersStatusArray.append(String(format: Constants.Localize.ActionMessage.StatusWin, arguments: [player.name]))
                }
            } else {
                // ... altrimenti aggiungo a chi tocca (se ci sono giocatori sufficienti)
                if (RulesManager.isPlayable(players: self.statusPlayersManager.playersArray)) {
                    if let player = self.statusPlayersManager.getActivePlayer() {
                        playersStatusArray.append(String(format: Constants.Localize.ActionMessage.StatusNext, player.name))
                    } else if let player = self.statusPlayersManager.playersArray.first {
                        playersStatusArray.append(String(format: Constants.Localize.ActionMessage.StatusNext, player.name))
                    }
                }
            }
            
            outputMessage += playersStatusArray.joined(separator: Constants.Localize.ActionMessage.StatusConnector)
        } else {
            outputMessage += Constants.Localize.ActionMessage.StatusNoPlayers
        }
        
        return outputMessage
    }
    
    private func performAuxiliaryExit() -> String {
        // aggiorno lo status
        self.statusPlayersManager.updateActionExit()
        
        return Constants.Localize.ActionMessage.Exit1
    }
    
    
// MARK: perform movement
    private func preMovementAction(_ action: Action) -> String? {
        var outputMessage: String? = nil
        
        switch action.type {
            case .Move:
                outputMessage = self.performPreMove(action as! ActionMove)
            default:
                break
        }
        
        return outputMessage
    }
    
    private func performPreMove(_ action: ActionMove) -> String? {
        // azioni preliminati al movimento
        return self.statusPlayersManager.canMove(action)
    }
    
    private func performMovementAction(_ action: Action) -> [ActionMove] {
        var specialAction = [ActionMove]()

        switch action.type {
            case .Move:
                specialAction = self.performMove(action as! ActionMove)
            case .MoveSpecial:
                specialAction = self.performMoveSpecial(action as! ActionMove)
            default:
                break
        }
        
        return specialAction
    }
    
    private func postMovementAction(_ action: Action) {
        switch action.type {
            case .Move:
                self.statusPlayersManager.nextPlayer()
            default:
                break
        }
    }
    
    private func performMove(_ action: ActionMove) -> [ActionMove] {
        guard let player = self.statusPlayersManager.getPlayerByName(action.player) else {
            // se non c'è il player, non faccio nulla
            return []
        }
        
        if !self.statusPlayersManager.isOn() || (player.name != action.player) {
            // se lo stato non è attivo e non è il mio turno, non faccio nulla
            return []
        } else {
            // è il mio turno, devo muovere

            // eseguo l'action sul player
            player.move(action: action)
            
            // controllo la situazione dei players, e genero eventualmente ActionMoveSpecial
            return checkAndGenerateMoveSpecial(player: player, distance: action.dice1 + action.dice2)
        }
    }
    
    private func performMoveSpecial(_ action: ActionMove) -> [ActionMove] {
        guard let player = self.statusPlayersManager.getPlayerByName(action.player) else {
            // se non c'è il player, non faccio nulla
            return []
        }
        
        if !self.statusPlayersManager.isOn() {
            // se lo stato non è attivo, non faccio nulla
            return []
        } else {
            // devo muovere
            
            // eseguo l'action sul player
            player.move(action: action)
            
            // controllo la situazione dei players, e genero eventualmente ActionMoveSpecial
            return checkAndGenerateMoveSpecial(player: player, distance: action.dice1 + action.dice2)
        }
    }
    
    private func checkAndGenerateMoveSpecial(player: Player, distance: Int) -> [ActionMove] {
        var specialAction = [ActionMove]()
        
        // controllo se sono finito sopra a qualche altro player
        if let playerUnder = RulesManager.isOnPlayers(player: player, players: self.statusPlayersManager.playersArray) {
            specialAction.append(self.specialMoveSwap(playerOver: player, playerUnder: playerUnder))
        }
        
        // controllo se sono su una casella goose
        if RulesManager.isOnGoose(player) {
            specialAction.append(self.specialMoveGoose(player: player, distance: distance))
        }
        
        // controllo se sono su una casella ponte
        if RulesManager.isOnBridge(player) {
            specialAction.append(self.specialMoveBridge(player))
        }
        
        return specialAction
    }
    
    func specialMoveGoose(player: Player, distance: Int) -> ActionMove {
        // sono su una casella Goose -> rifaccio la distanza che ho appena fatto
        
        // creazione mossa ActionMoveSpecial, positiva
        return ActionMove.actionMoveGoose(player: player.name, dice: distance)
    }
    
    func specialMoveBridge(_ player: Player) -> ActionMove {
        // sono su una casella Bridge -> raddoppio la posizione
        
        // creazione mossa ActionMoveSpecial, positiva
        return ActionMove.actionMoveBridge(player: player.name, dice: player.actualPosition)
    }
    
    func specialMoveSwap(playerOver: Player, playerUnder: Player) -> ActionMove {
        // playerOver è andato sopra player: quindi self rimane sulla posizione di playerUnder, e playerUnder deve prendere la previousPosition di playerOver
        
        // creazione mossa ActionMoveSpecial, negativa
        return ActionMove.actionMoveSwap(player: playerUnder.name, dice: playerOver.previousPosition - playerUnder.actualPosition)
    }
    
    
// MARK: message movement
    private func movementMessage(action: Action) -> String {
        var outputMessage : String?
        
        switch action.type {
            case .Move:
                outputMessage = self.messageMove(action as! ActionMove)
            case .MoveSpecial:
                outputMessage = self.messageMoveSpecial(action as! ActionMove)
            default:
                break
        }
        
        return outputMessage ?? ""
    }

    private func messageMove(_ action: ActionMove) -> String {
        // mi prendo il player corrispondente
        guard let player = self.statusPlayersManager.getPlayerByName(action.player) else {
            return Constants.Localize.ActionMessage.Error
        }
        
        // creo la prima parte del messaggio, uguale in ogni condizione
        var outputMessage = String(format: Constants.Localize.ActionMessage.Move1, arguments: [action.player, action.dice1.string, action.dice2.string])
        outputMessage += String(format: Constants.Localize.ActionMessage.Move2, arguments: [action.player, player.previousPosition.string])
        
        // controllo se sono su caselle speciali
        if RulesManager.isOnBridge(player) {
            // bridge
            outputMessage += Constants.Localize.ActionMessage.MoveBridge3
        } else if RulesManager.isOnGoose(player) {
            // goose
            outputMessage += String(format: Constants.Localize.ActionMessage.MoveGoose3, self.statusPlayersManager.maxPositionWhileMove(action: action).string)
        } else {
            // standard
            outputMessage += String(format: Constants.Localize.ActionMessage.Move3, self.statusPlayersManager.maxPositionWhileMove(action: action).string)
        }
        
        if self.statusPlayersManager.isWin() {
            // ho vinto
            outputMessage += String(format: Constants.Localize.ActionMessage.MoveCommonWin, action.player)
        } else if self.statusPlayersManager.isBounced(action: action) {
            // bounce
            outputMessage += String(format: Constants.Localize.ActionMessage.MoveCommonBounce, arguments: [action.player, action.player, player.actualPosition.string])
        }
        
        return outputMessage
    }
    
    private func messageMoveSpecial(_ action: ActionMove) -> String {
        // mi prendo il player corrispondente
        guard let player = self.statusPlayersManager.getPlayerByName(action.player) else {
            return Constants.Localize.ActionMessage.Error
        }
        
        var outputMessage : String
        switch action.moveType {
            case .Bridge:
                outputMessage = String(format: Constants.Localize.ActionMessage.MoveSpecialBridge1, arguments: [action.player, player.actualPosition.string])
            case .Goose:
                outputMessage = String(format: Constants.Localize.ActionMessage.MoveSpecialGoose1, action.player)
                if RulesManager.isOnGoose(player) {
                    // goose
                    outputMessage += String(format: Constants.Localize.ActionMessage.MoveSpecialGoose2Goose, self.statusPlayersManager.maxPositionWhileMove(action: action).string)
                } else {
                    // standard
                    outputMessage += String(format: Constants.Localize.ActionMessage.MoveSpecialGoose2Normal, self.statusPlayersManager.maxPositionWhileMove(action: action).string)
                }
            case .Swap:
                outputMessage = String(format: Constants.Localize.ActionMessage.MoveSpecialSwap1, arguments: [player.previousPosition.string, action.player, player.actualPosition.string])
            default:
                return Constants.Localize.ActionMessage.Error
        }
        
        if self.statusPlayersManager.isWin() {
            // ho vinto
            outputMessage += String(format: Constants.Localize.ActionMessage.MoveCommonWin, action.player)
        } else if self.statusPlayersManager.isBounced(action: action) {
            // bounce
            outputMessage += String(format: Constants.Localize.ActionMessage.MoveCommonBounce, arguments: [action.player, action.player, player.actualPosition.string])
        }
        
        return outputMessage
    }
}
