//
//  card.swift
//  04 CardGame
//
//  Created by Wuhuijuan on 2021/12/17.
//

import Foundation

/**
    卡片模型
 isFaceUp：是否翻面状态
 isMatched：是否匹配状态
 isFade：是否处于消失状态
 identifier：卡片的图像，或者说卡片的标识
 */
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
