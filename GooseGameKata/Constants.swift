//
//  Constants.swift
//  GooseGameKata
//
//  Created by Daniele99999999 on 16/06/18.
//  Copyright © 2018 Daniele99999999. All rights reserved.
//

import Foundation

public enum Constants {
    
    public enum Test {
        static let ConfigurationFileName = "Configuration"
        static let ConfigurationNoSpecialFileName = "ConfigurationNoSpecial"
        static let BaseCommandOK = ".Command.OK"
        static let BaseCommandKO = ".Command.KO"
        static let BaseListOK = ".List" + BaseCommandOK
        static let BaseMessage = ".Message"
    }
    
    public enum Localize {
        
        public enum ActionToParse {
            static let Help1 = "help".localized()
            
            static let Add1 = "add".localized()
            static let Add2 = "player".localized()
            
            static let Move1 = "move".localized()
            
            static let Status1 = "status".localized()
            
            static let Turn1 = "turn".localized()
            
            static let Exit1 = "exit".localized()
        }
        
        public enum ActionMessage {
            static let Help0 = "******************************************************************"
            static let Help1 = "*                         The Goose Game                         *".localized()
            static let Help2 = "* help              - This Menu                                  *".localized()
            static let Help3 = "* add player \"name\" - add a new player to the game               *".localized()
            static let Help4 = "* move \"name\"       - system throws the dice and move the marker *".localized()
            static let Help5 = "* move \"name\" 1, 2  - player throws the dice and move the marker *".localized()
            static let Help6 = "* status            - show current standings                     *".localized()
            static let Help7 = "* exit              - terminate game                             *".localized()
            static let Help8 = "***************++*************************************************"
            
            static let Add1 = "players: ".localized()
            static let AddConnector = ", "
            static let AddExistanceError = "%@: already existing player".localized()
            static let AddIllegalStatusError = "adding player %@ not possible in this state".localized()
            
            static let Move1 = "%@ rolls %@, %@. ".localized()
            static let Move2 = "%@ moves from %@ to ".localized()
            static let Move3 = "%@. ".localized()
            static let MoveBridge3 = "The Bridge. ".localized()
            static let MoveGoose3 = "%@, The Goose. ".localized()
            static let MoveFewPlayersError = "actual players: %@ are less than minimum necessary for play: %@".localized()
            static let MoveExistanceError  = "%@: player does not exist".localized()
            static let MoveIllegalStatusError = "moving player %@ not possible in this state".localized()
            static let MoveWrongTurnError = "moving player %@ is not possible because %@ has to move first".localized()
            
            static let MoveSpecialBridge1 = "%@ jump to %@. ".localized()
            static let MoveSpecialGoose1 = "%@ moves again and goes to ".localized()
            static let MoveSpecialGoose2Normal = "%@. ".localized()
            static let MoveSpecialGoose2Goose = "%@, The Goose. ".localized()
            static let MoveSpecialSwap1 = "On %@ there is %@, who returns to %@. ".localized()
            
            static let MoveCommonBounce = "%@ bounces! %@ returns to %@. ".localized()
            static let MoveCommonWin = "%@ Wins!!".localized()
            
            static let Status1 = "status: ".localized()
            static let Statusn = "%@ is in position %@".localized()
            static let StatusNext = "%@ is next one to move".localized()
            static let StatusWin = "%@ is winner!".localized()
            static let StatusConnector = ", "
            static let StatusNoPlayers = "no players".localized()
            
            static let Exit1 = "game terminated, goodbye!".localized()
            
            static let Error = "ERROR EXCEPTION. ".localized()
            static let ErrorIllegalStatus = "command not available in this state".localized()
            static let ErrorIllegalCommand = "command not valid".localized()
        }
    }
}
