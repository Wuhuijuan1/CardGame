//
//  AppDelegate.swift
//  04 CardGame
//
//  Created by Wuhuijuan on 2021/12/17.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        let cardVC = GameModeController()
        let nav = UINavigationController(rootViewController: cardVC)
        window?.rootViewController = nav
        window?.makeKeyAndVisible()
        return true
    }
}

