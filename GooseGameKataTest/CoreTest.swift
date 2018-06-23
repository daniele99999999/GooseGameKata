//
//  CoreTest.swift
//  GooseGameKataTest
//
//  Created by Daniele99999999 on 22/06/18.
//  Copyright © 2018 Daniele99999999. All rights reserved.
//

import XCTest
import Foundation
import SwifterSwift

class CoreTest {
    
    var configuration: Configuration
    
    var parser: ActionParser
    var statusManager: StatusPlayersManager
    var actionManager: ActionsProtocol
    
    private init(configuration: Configuration) {
        self.configuration = configuration
        self.parser = ActionParser()
        self.statusManager = StatusPlayersManager()
        self.actionManager = ActionManager(statusPlayersManager: self.statusManager)
    }
    
    convenience init(configurationFileName: String) {
        let configuration = StorageUtils.loadJSON(name: configurationFileName, bundle: Bundle(for: GooseGameKataTest.self)) ?? Configuration()
        self.init(configuration: configuration)
    }
    
    func updateConfiguration(_ fileName: String) {
        self.updateConfiguration(StorageUtils.loadJSON(name: fileName, bundle: Bundle(for: GooseGameKataTest.self)) ?? Configuration())
    }
    
    func updateConfiguration(_ configuration: Configuration) {
        self.configuration = configuration
        
        RulesManager.configuration = configuration
    }
    
    func setUp() {
        
    }
    
    func tearDown() {
        
    }
    

// MARK: utils
    func loadElement(_ fileName: String) -> String {
        let elementTest: ElementStringTest? = StorageUtils.loadJSON(name: fileName, bundle: Bundle(for: GooseGameKataTest.self))
        return elementTest?.element ?? ""
    }
    
    func loadElementList(_ fileName: String) -> [String] {
        guard let elementListTest: [ElementStringTest] = StorageUtils.loadJSON(name: fileName, bundle: Bundle(for: GooseGameKataTest.self)) else {
            return []
        }
        
        return elementListTest.map({$0.element})
    }
    
    
// MARK: parse command
    func parseCommandFailure(_ command: String) {
        let inputString = self.loadElement(command + Constants.Test.BaseCommandKO)
        
        self.parser.parseAction(input: inputString,
                                actionBlock: { (action) in
                                    XCTFail()
        }) { (message) in
            XCTAssertTrue(true)
        }
    }
    
    func parseCommandSuccess(_ command: String) {
        self.parseCommandSuccess(command: command, actionType: ActionType(rawValue: command.components(separatedBy: CharacterSet.decimalDigits).joined())!)
    }
    
    func parseCommandSuccess(command: String, actionType: ActionType) {
        let inputString = self.loadElement(command + Constants.Test.BaseCommandOK)
        
        self.parser.parseAction(input: inputString,
                                actionBlock: { (action) in
                                    XCTAssertEqual(action.type, actionType)
        }) { (message) in
            XCTFail()
        }
    }
    
    func parseCommandSuccessAndCheckMessage(_ command: String) {
        self.parseCommandSuccessAndCheckMessage(command: command, formatStringArguments: [])
    }
    
    func parseCommandSuccessAndCheckMessage(command: String, formatStringArguments: [String]) {
        let inputString = self.loadElement(command + Constants.Test.BaseCommandOK)
        var outputMessage = self.loadElement(command + Constants.Test.BaseMessage)
        if formatStringArguments.count > 0 {
            outputMessage = String(format: outputMessage, arguments: formatStringArguments)
        }
        
        self.parser.parseAction(input: inputString,
                                actionBlock: { (action) in
                                    let outputString = self.actionManager.manageAction(action)
                                    XCTAssertEqual(outputString, outputMessage)
        }) { (message) in
            XCTFail()
        }
    }
    
    func parseCommandSuccessAndCheckMessageRegex(command: String, outputRegexMessage: String) {
        let inputString = self.loadElement(command + Constants.Test.BaseCommandOK)
        
        self.parser.parseAction(input: inputString,
                                actionBlock: { (action) in
                                    let outputString = self.actionManager.manageAction(action)
                                    XCTAssertTrue(outputString.matches(pattern: outputRegexMessage))
        }) { (message) in
            XCTFail()
        }
    }
    
    
// MARK: action loop
    func parseCommandList(_ commandList: String) {
        // ottengo la lista dei comandi
        let commandStringList: [String] = self.loadElementList(commandList + Constants.Test.BaseListOK)
        let outputMessage = self.loadElement(commandList + Constants.Test.BaseMessage)
        
        self.parseStepList(commandList: commandStringList, outputMessage: outputMessage)
    }
    
    private func parseStepList(commandList: [String], outputMessage: String) {
        
        if let inputString = commandList.first {
            // aggiorno la commandList
            var commandListMod = commandList
            commandListMod.removeFirst()
            
            if commandListMod.count > 0 {
                // n-esimo comando
                
                // lo eseguo
                self.parser.parseAction(input: inputString,
                                        actionBlock: { (action) in
                                            let outputString = self.actionManager.manageAction(action)
                                            XCTAssertNotEqual(outputString, Constants.Localize.ActionMessage.ErrorIllegalCommand)
                                            // chiamo ricorsivamente
                                            self.parseStepList(commandList: commandListMod, outputMessage: outputMessage)
                }) { (message) in
                    XCTFail()
                }
            } else {
                // ultimo comando
                
                self.parser.parseAction(input: inputString,
                                        actionBlock: { (action) in
                                            let outputString = self.actionManager.manageAction(action)
                                            XCTAssertEqual(outputString, outputMessage)
                }) { (message) in
                    XCTFail()
                }
            }
        } else {
            XCTFail()
        }
    }
}
