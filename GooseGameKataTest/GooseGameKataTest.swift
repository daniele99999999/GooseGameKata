//
//  GooseGameKataTest.swift
//  GooseGameKataTest
//
//  Created by Daniele99999999 on 22/06/18.
//  Copyright © 2018 Daniele99999999. All rights reserved.
//

import XCTest
@testable import GooseGameKata
import Foundation
import SwifterSwift

class GooseGameKataTest: XCTestCase {
    
    var coreTest: CoreTest!
    
    override func setUp() {
        super.setUp()
        self.coreTest = CoreTest(configurationFileName: Constants.Test.ConfigurationFileName)
    }
    
    override func tearDown() {
        self.coreTest = nil
        super.tearDown()
    }

    
// MARK: command
    func test01HelpKO() {
        self.coreTest.setUp()
        self.coreTest.parseCommandFailure("Help")
        self.coreTest.tearDown()
    }

    func test02HelpOK() {
        self.coreTest.setUp()
        self.coreTest.parseCommandSuccess("Help")
        self.coreTest.tearDown()
    }

    func test03HelpMessage() {
        self.coreTest.setUp()
        self.coreTest.parseCommandSuccessAndCheckMessage("Help")
        self.coreTest.tearDown()
    }

    func test04AddKO() {
        self.coreTest.setUp()
        self.coreTest.parseCommandFailure("Add")
        self.coreTest.tearDown()
    }

    func test05AddOK() {
        self.coreTest.setUp()
        self.coreTest.parseCommandSuccess("Add1")
        self.coreTest.tearDown()
    }

    func test06AddMessage() {
        self.coreTest.setUp()
        self.coreTest.parseCommandSuccessAndCheckMessage("Add1")
        self.coreTest.parseCommandSuccessAndCheckMessage("Add2")
        self.coreTest.parseCommandSuccessAndCheckMessage("Add3")
        self.coreTest.tearDown()
    }

    func test07MoveKO() {
        self.coreTest.setUp()
        self.coreTest.parseCommandFailure("Move1")
        self.coreTest.parseCommandFailure("Move2")
        self.coreTest.parseCommandFailure("Move3")
        self.coreTest.tearDown()
    }

    func test08MoveOK() {
        self.coreTest.setUp()
        self.coreTest.parseCommandSuccess("Move1")
        self.coreTest.parseCommandSuccess("Move2")
        self.coreTest.tearDown()
    }

    func test09MoveMessage() {
        self.coreTest.setUp()
        self.coreTest.parseCommandSuccessAndCheckMessage("Add1")
        self.coreTest.parseCommandSuccessAndCheckMessage(command: "Move1", formatStringArguments: [self.coreTest.statusManager.playersArray.count.string,
                                                                                                   self.coreTest.configuration.MinNumberOfPlayers.string])
        self.coreTest.parseCommandSuccessAndCheckMessage("Add2")
        self.coreTest.parseCommandSuccessAndCheckMessage("Move2")
        self.coreTest.parseCommandSuccessAndCheckMessage("Move3")
        self.coreTest.tearDown()
    }

    func test10MoveMessage() {
        self.coreTest.setUp()
        self.coreTest.parseCommandSuccessAndCheckMessage("Add1")
        self.coreTest.parseCommandSuccessAndCheckMessage("Add2")
        self.coreTest.parseCommandSuccessAndCheckMessage("Move4")
        self.coreTest.tearDown()
    }

    func test11StatusKO() {
        self.coreTest.setUp()
        self.coreTest.parseCommandFailure("Status")
        self.coreTest.tearDown()
    }

    func test12StatusOK() {
        self.coreTest.setUp()
        self.coreTest.parseCommandSuccess("Status1")
        self.coreTest.tearDown()
    }

    func test13StatusMessage() {
        self.coreTest.setUp()
        self.coreTest.parseCommandSuccessAndCheckMessage("Status1")
        self.coreTest.parseCommandSuccessAndCheckMessage("Add1")
        self.coreTest.parseCommandSuccessAndCheckMessage("Add2")
        self.coreTest.parseCommandSuccessAndCheckMessage("Move4")
        self.coreTest.parseCommandSuccessAndCheckMessage("Status2")
        self.coreTest.tearDown()
    }

    func test14ExitKO() {
        self.coreTest.setUp()
        self.coreTest.parseCommandFailure("Exit")
        self.coreTest.tearDown()
    }

    func test15ExitOK() {
        self.coreTest.setUp()
        self.coreTest.parseCommandSuccess("Exit")
        self.coreTest.tearDown()
    }

    func test16ExitMessage() {
        self.coreTest.setUp()
        self.coreTest.parseCommandSuccessAndCheckMessage("Exit")
        self.coreTest.tearDown()
    }


// MARK: command list
    func test17BridgeMessage() {
        self.coreTest.setUp()
        self.coreTest.parseCommandList("Bridge1")
        self.coreTest.tearDown()
    }

    func test18GooseMessage() {
        self.coreTest.setUp()
        self.coreTest.parseCommandList("Goose1")
        self.coreTest.tearDown()
    }

    func test19GooseDoubleMessage() {
        self.coreTest.setUp()
        self.coreTest.parseCommandList("Goose2")
        self.coreTest.tearDown()
    }

    func test20PrankMessage() {
        self.coreTest.setUp()
        self.coreTest.parseCommandList("Prank1")
        self.coreTest.tearDown()
    }

    func test21WinMessage() {
        self.coreTest.setUp()
        self.coreTest.parseCommandList("Win1")
        self.coreTest.tearDown()
    }
    
    func test22WinReboundMessage() {
        self.coreTest.setUp()
        self.coreTest.parseCommandList("Win2")
        self.coreTest.tearDown()
    }
}
