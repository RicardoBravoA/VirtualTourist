//
//  AppDelegate.swift
//  VirtualTourist
//
//  Created by Ricardo Bravo on 2/07/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let dataController = DataController.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        dataController.load()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        dataController.save()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        dataController.save()
    }

}

