//
//  CardViewController.swift
//  04 CardGame
//
//  Created by Wuhuijuan on 2022/9/6.
//

import Foundation
import UIKit
import SnapKit

class CardViewController: UIViewController {
    private var buttonArray: [UIButton] = []
    private var timeItem = UIBarButtonItem(title: "00:00", style: .plain, target: nil, action: nil)
    private var cardIndexArray: [Int] = []
    private var timer: Timer?
    private var interval = 0
    private let fadeColor = UIColor.clear
    private let bacColor = UIColor.yellow.withAlphaComponent(0.6)
    private let faceColor = UIColor.lightGray.withAlphaComponent(0.6)
    var identifierArray = ["🐸","🙊","🦀","🐙","🐯","🐥","🐝","🐌","🤡","🐛","🐼","🐲","🎃","🌞","🏆","🍔","⚽️","🏀","🚑","🚒","🕍","🥭","🍈","🥒","🥃","🧘🏻‍♀️","🏖","🌆","🌅","⏰","🛁","🎉","💝","❤️‍🔥","🇲🇰","🇹🇱","🇪🇨","🇹🇬","🇩🇲","🥝","🍧","🍨","🍺"]
    var emoji = [Int : String]()
    private var game = Concentration(1)
    // 第一个参数表示行，第二个参数表示列
    var arrangement: (UInt, UInt) = (0, 0) {
        didSet {
            updateUI()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNavigation()
        installUI()
        updateTimer()
        game = Concentration(buttonArray.count)
    }
    
    
    func emoji(card:Card) -> String {
        var index = 0
        while cardIndexArray.contains(index) {
            index = Int(arc4random()) % identifierArray.count
        }
        if emoji[card.identifier] == nil {
            emoji[card.identifier] = identifierArray[index]
            cardIndexArray.append(index)
        }
        return emoji[card.identifier] ?? "?"
    }
    
    func updateTimer() {
        timer?.invalidate()
        timer = nil
        interval = 0
        self.timeItem.title = "00:00"
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            guard let self = self else { return }
            self.interval += 1
            let minites = self.interval / 60
            let seconds = self.interval % 60
            self.timeItem.title = String(format: "%02d:%02d", minites, seconds)
        })
    }
}

// MARK: - 按钮点击事件
extension CardViewController {
    @objc func cardDidClicked(_ sender: UIButton) {
        game.chooseCard(at: sender.tag)
        reloadUI()
    }
    
    @objc func refreshDidClicked() {
        updateUI()
    }
}


// MARK: - loadUI
extension CardViewController {
    private func loadNavigation() {
        let refreshItem = UIBarButtonItem(image: UIImage(named: "tools_refresh"), style: .plain, target: self, action: #selector(refreshDidClicked))
        
        self.navigationItem.rightBarButtonItems = [refreshItem, timeItem]
    }
    private func updateUI() {
        self.view.subviews.forEach { view in
            view.removeFromSuperview()
        }
        buttonArray.removeAll()
        cardIndexArray.removeAll()
        installUI()
        updateData()
        updateTimer()
        game = Concentration(buttonArray.count)
    }

    private func installUI() {
        let imageView = UIImageView(image: UIImage(named: "cardBac"))
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        var stackArr: [UIStackView] = []
        for i in 0..<arrangement.0 {
            var buttonArr: [UIButton] = []
            for idx in 0..<arrangement.1 {
                let button = UIButton()
                button.backgroundColor = bacColor
                button.tag = Int(i * arrangement.1 + idx)
                button.addTarget(self, action: #selector(cardDidClicked(_:)), for: .touchUpInside)
                buttonArr.append(button)
                self.buttonArray.append(button)
            }
            let stackView = UIStackView(arrangedSubviews: buttonArr)
            stackView.axis = .horizontal
            stackView.spacing = 16
            stackView.distribution = .fillEqually
            stackArr.append(stackView)
        }
        
        let stackView = UIStackView(arrangedSubviews: stackArr)
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-32)
        }
    }
    
    func reloadUI() {
        //遍历Button数组
        var isAllFade = true
        var newMatchedArr: [UIButton] = []
        for index in buttonArray.indices {
            let button = buttonArray[index]
            let card = game.cards[index]
            if card.isMatched && card.isFaceUp {
                newMatchedArr.append(buttonArray[index])
            }
            if card.isFade {
                button.setAttributedTitle(nil, for: .normal)
                button.backgroundColor = fadeColor
            }else if card.isMatched {
                button.backgroundColor = .lightGray
                button.alpha = 1
                UIView.animate(withDuration: 0.25, delay: 0.25, options: .curveLinear) {
                    let title = self.attributeTitle(of: self.emoji(card: card))
                    button.setAttributedTitle(title, for: .normal)
                    button.alpha = 0.5
                } completion: { _ in
                    UIView.animate(withDuration: 0.25, delay: 0.25) {
                        button.setAttributedTitle(nil, for: .normal)
                        button.backgroundColor = self.fadeColor
                    }
                }
                game.cards[index].isFade = true
            } else if card.isFaceUp {
                isAllFade = false
                let title = self.attributeTitle(of: self.emoji(card: card))
                button.setAttributedTitle(title, for: .normal)
                button.backgroundColor = faceColor
            } else {
                isAllFade = false
                button.setAttributedTitle(nil, for: .normal)
                button.backgroundColor = bacColor
            }
        }
        
        if isAllFade {
            timer?.invalidate()
            timer = nil
            let alert = UIAlertController(title:  "Congratulation!", message: "通关完成！用时: " + (timeItem.title ?? "00:00"), preferredStyle: .alert)
            let quit = UIAlertAction(title: "退出", style: .default) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            }
            let again = UIAlertAction(title: "重来", style: .default) { [weak self] _ in
                self?.updateUI()
            }
            alert.addAction(quit)
            alert.addAction(again)
            self.present(alert, animated: true)
        }
    }
    
    private func attributeTitle(of text: String) -> NSAttributedString {
        let fontSize = (buttonArray.first?.bounds.width ?? 40) - 20
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)]
        let attibuteString = NSAttributedString(string: text, attributes: attributes)
        return attibuteString
    }
    
    private func updateData() {
        let count = identifierArray.count
        for _ in 1...count {
            let i = Int(arc4random()) % count
            let j = Int(arc4random()) % count
            if i != j {
                identifierArray.swapAt(i, j)
            }
        }
    }
}
