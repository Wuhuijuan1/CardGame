//
//  Concentration.swift
//  04 CardGame
//
//  Created by Wuhuijuan on 2021/12/17.
//

import UIKit

class Concentration {
    var cards = [Card]()
    var OnlyOneFaceUpIndex : Int?
    
    func chooseCard(at index:Int) {
        //判断卡片的情况：1.一张face up
        if OnlyOneFaceUpIndex == nil || index == OnlyOneFaceUpIndex {
            cards[index].isFaceUp.toggle()
            OnlyOneFaceUpIndex = cards[index].isFaceUp == true ? index : nil
        } else { // 翻转第二张
            guard let preIndex = OnlyOneFaceUpIndex else {
                return
            }
            cards[index].isFaceUp = true
            if cards[index].identifier == cards[preIndex].identifier {
                cards[index].isMatched = true
                cards[preIndex].isMatched = true
                OnlyOneFaceUpIndex = nil
            } else {
                cards[preIndex].isFaceUp = false
                OnlyOneFaceUpIndex = index
            }
        }
    }
    
    init(_ cardCount: Int) {
        //获取一个随机数
        for _ in 1...cardCount {
            let card = Card()
            cards += [card, card]
        }
        for _ in 1...cardCount {
            let i = Int(arc4random()) % cardCount
            let j = Int(arc4random()) % cardCount
            if i != j {
                cards.swapAt(i, j)
            }
        }
    }
}
