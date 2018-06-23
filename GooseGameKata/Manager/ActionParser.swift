//
//  ActionParser.swift
//  GooseGameKata
//
//  Created by Daniele99999999 on 16/06/18.
//  Copyright © 2018 Daniele99999999. All rights reserved.
//

import Foundation
import SwifterSwift

protocol ParserProtocol {
    func parseAction(input:String,
                     actionBlock:@escaping (_ action: Action) -> Void,
                     errorMessage:@escaping (_ message: String) -> Void)
}

class ActionParser: ParserProtocol {
    func parseAction(input:String,
                     actionBlock:@escaping (_ action: Action) -> Void,
                     errorMessage:@escaping (_ message: String) -> Void) {
        // parso l'input, splitto per spazi
//        var words = input.words()
        var words = input.components(separatedBy: .whitespaces)
        
        switch words.count {
            case 1: // help, status, exit
                // prendo l'unico elemento
                let commandElement = words.removeFirst()
                
                // controllo se è un comando valido o meno
                switch commandElement {
                    case Constants.Localize.ActionToParse.Help1:
                        actionBlock(ActionHelpStatusExit.actionHelp())
                    case Constants.Localize.ActionToParse.Status1:
                        actionBlock(ActionHelpStatusExit.actionStatus())
                    case Constants.Localize.ActionToParse.Exit1:
                        actionBlock(ActionHelpStatusExit.actionExit())
                    default:
                        errorMessage(Constants.Localize.ActionMessage.ErrorIllegalCommand)
                }
            
            case 2: // move senza dadi
                if (words[0] == Constants.Localize.ActionToParse.Move1) &&
                   RulesManager.validPlayerName(words[1]) {
                    actionBlock(ActionMove.actionMoveStandard(player: words[1], dice1: RulesManager.rollDice(), dice2: RulesManager.rollDice()))
                } else {
                    errorMessage(Constants.Localize.ActionMessage.ErrorIllegalCommand)
                }
            
            case 3: // add player
                if (words[0] == Constants.Localize.ActionToParse.Add1) &&
                   (words[1] == Constants.Localize.ActionToParse.Add2) &&
                   RulesManager.validPlayerName(words[2]) {
                    actionBlock(ActionAdd(player: words[2]))
                } else {
                    errorMessage(Constants.Localize.ActionMessage.ErrorIllegalCommand)
                }
            
            case 4: // move con dadi
                // estraggo i potenziali dadi
                if (words[0] == Constants.Localize.ActionToParse.Move1) &&
                   RulesManager.validPlayerName(words[1]) &&
                   RulesManager.validDice1(words[2]) &&
                   RulesManager.validDice2(words[3]) {
                    actionBlock(ActionMove.actionMoveStandard(player: words[1], dice1: RulesManager.cleanDice(words[2])!, dice2: RulesManager.cleanDice(words[3])!))
                } else {
                    errorMessage(Constants.Localize.ActionMessage.ErrorIllegalCommand)
                }

            default: // comando sconosciuto
                errorMessage(Constants.Localize.ActionMessage.ErrorIllegalCommand)
        }
    }
}
