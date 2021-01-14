//
//  AppDelegate.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/02.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var coordinators: [Coordinator]?
    @UserDefaultsBacked(key: .didFinishLaunching, defaultValue: false)
    var didCompleteSetup: Bool
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow()
        let tabBarController = UITabBarController()
        
        coordinators = createTabBarCoordinators(tabBarController: tabBarController).map { $0.start() }
        tabBarController.viewControllers = coordinators?.map { $0.navigationController }
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

func createTabBarCoordinators(tabBarController: UITabBarController) -> [Coordinator] {
    [
        HomeCoordinator(tabBarController), // pass in the tab bar controller
        StatusCoordinator(tabBarController),
        ProfileCoordinator(tabBarController)
    ]
}
