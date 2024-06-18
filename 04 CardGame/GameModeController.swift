//
//  ModelController.swift
//  04 CardGame
//
//  Created by Wuhuijuan on 2022/9/7.
//

import Foundation
import UIKit
import RxSwift

class GameModeController: UIViewController {
    private let operateView = OperateView()
    private let disposBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = UIImage(named: "bac") {
            view.backgroundColor = UIColor(patternImage: image)
        }
        installUI()
        bindViewModel()
    }
    
    private func installUI() {
        let titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        let attributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 56)] as [NSAttributedString.Key : Any]
        titleLabel.attributedText = NSAttributedString(string: "Card Game", attributes: attributes)
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(48)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(56)
        }

        view.addSubview(operateView)
        operateView.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-100)
            make.height.equalToSuperview().multipliedBy(0.5)
            make.leading.equalToSuperview().offset(32)
            make.centerX.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        operateView.modeDidSelectedSubject.subscribe { [weak self] tag in
            guard let index = tag.element, let self = self else { return }
            var gameMode: GameMode
            switch index {
            case 10:
                gameMode = .easy
            case 20:
                gameMode = .middle
            case 30:
                gameMode = .hard
            case 40:
                gameMode = .hell
            default:
                return
            }
            let cardVC = CardViewController(mode: gameMode)
            self.navigationController?.pushViewController(cardVC, animated: true)
        }
        .disposed(by: disposBag)
    }
}
