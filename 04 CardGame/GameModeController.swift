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
            var arrangement: (UInt, UInt) = (0, 0)
            switch index {
            case 10:
                arrangement = (4, 3)
            case 20:
                arrangement = (4, 4)
            case 30:
                arrangement = (5, 4)
            case 40:
                arrangement = (6, 5)
            default:
                return
            }
            let cardVC = CardViewController()
            cardVC.arrangement = arrangement
            self.navigationController?.pushViewController(cardVC, animated: true)
        }
        .disposed(by: disposBag)
    }
}
