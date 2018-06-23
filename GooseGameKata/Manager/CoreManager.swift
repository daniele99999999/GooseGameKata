//
//  CoreManager.swift
//  GooseGameKata
//
//  Created by Daniele99999999 on 16/06/18.
//  Copyright © 2018 Daniele99999999. All rights reserved.
//

import Foundation

protocol CoreProtocol {
    func mainLoop()
}

class CoreManager: CoreProtocol {
    
    private let parser: ParserProtocol
    private let statusManager: StatusPlayerProtocol
    private let actionManager: ActionsProtocol
    
    init(parser: ParserProtocol,
         statusManager: StatusPlayerProtocol,
         actionManager: ActionsProtocol,
         configuration: Configuration = Configuration()) {
        self.parser = parser
        self.statusManager = statusManager
        self.actionManager = actionManager
        
        RulesManager.configuration = configuration
    }
    
    func mainLoop() {
        // inizialmente lancio manualmente il comando help, così da mostrare a video la lista dei comandi
        print(self.actionManager.manageAction(ActionHelpStatusExit.actionHelp()))
        
        // entro nel mainLoop di esecuzione
        repeat {
            // catturo l'input
            let inputString = readLine()
            
            // parso l'input
            self.parser.parseAction(input: inputString ?? "",
                                    actionBlock: { (action) in
                                        // comando valido: aggiungo alla coda di esecuzione
                                        let outputString = self.actionManager.manageAction(action)
                                        
                                        // stampo il log
                                        print(outputString)
            },
                                    errorMessage: { (message) in
                                        // comando non valido: stampo l'errore
                                        print(message)
            })
        } while (self.statusManager.isOn())
        
        // uscito dal mainLoop, gioco terminato
        // non devo stampare nulla, perchè in qualsiasi caso ho già stampato in precedenza dentro nel loop
    }
}
