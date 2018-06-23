//
//  main.swift
//  GooseGameKata
//
//  Created by Daniele99999999 on 14/06/18.
//  Copyright © 2018 Daniele99999999. All rights reserved.
//

import Foundation

let parser: ParserProtocol = ActionParser()
let statusManager: StatusPlayerProtocol = StatusPlayersManager()
let actionManager: ActionsProtocol = ActionManager(statusPlayersManager: statusManager)

let coreManager: CoreProtocol = CoreManager(parser: parser,
                                            statusManager: statusManager,
                                            actionManager: actionManager)
coreManager.mainLoop()
