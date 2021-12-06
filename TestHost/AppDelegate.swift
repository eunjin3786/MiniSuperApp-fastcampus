//
//  AppDelegate.swift
//  TestHost
//
//  Created by Jinny on 12/6/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    public var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        // Override point for customization after application launch.
        self.window = window
        return true
    }
}

