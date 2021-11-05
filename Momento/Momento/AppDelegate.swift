//
//  AppDelegate.swift
//  Momento
//
//  Created by Александр on 04.11.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let mainCoordinator = MainCoordinator()
        self.window?.rootViewController = mainCoordinator.rootNavController
        
        return true
    }


}

