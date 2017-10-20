//
//  AppDelegate.swift
//  Team4
//
//  Created by Julien Cayzac on 10/20/17.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    static var shared : AppDelegate! {
        get {
            return UIApplication.shared.delegate as! AppDelegate
        }
    }

    var window: UIWindow?
    var remoteCredentialManager: RemoteCredentialManager!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        remoteCredentialManager = RemoteCredentialManager()

        NotificationCenter.default.addObserver(self, selector: #selector(self.onLoggedIn), name: LocalCredentialManager.kLoggedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onLoggedOut), name: LocalCredentialManager.kLoggedOut, object: nil)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.

        // Stop advertising
        remoteCredentialManager.stopBroadcasting()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.

        if let _ = LocalCredentialManager.shared.loadUser() {
            remoteCredentialManager.startBroadcasting()
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    @objc func onLoggedIn() {
        remoteCredentialManager.startBroadcasting()
    }

    @objc func onLoggedOut() {
        remoteCredentialManager.stopBroadcasting()
    }
}

