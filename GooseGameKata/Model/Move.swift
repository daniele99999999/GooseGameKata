//
//  Move.swift
//  GooseGameKata
//
//  Created by Daniele99999999 on 22/06/18.
//  Copyright © 2018 Daniele99999999. All rights reserved.
//

enum MoveType: String, Codable {
    case Standard
    case Bridge
    case Goose
    case Swap
}

protocol Move: Codable {
    var moveType: MoveType {get}
}
