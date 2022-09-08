//
//  card.swift
//  04 CardGame
//
//  Created by Wuhuijuan on 2021/12/17.
//

import Foundation

struct Card {
    var isFaceUp = false
    var isMatched = false
    var isFade = false
    var identifier : Int
    static var onlyValue = 0
    static func getIdentifier() ->Int {
        Card.onlyValue += 1
        return Card.onlyValue;
    }
    
    init() {
        self.identifier = Card.getIdentifier()
    }
}
