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
        remoteCredentialManager = RemoteCredentialManager()

        NotificationCenter.default.addObserver(self, selector: #selector(self.onLoggedIn), name: .loggedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onLoggedOut), name: .loggedOut, object: nil)
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Stop advertising
        remoteCredentialManager.stopBroadcasting()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if let _ = LocalCredentialManager.shared.loadUser() {
            remoteCredentialManager.startBroadcasting()
        }
    }

    @objc func onLoggedIn() {
        remoteCredentialManager.startBroadcasting()
    }

    @objc func onLoggedOut() {
        remoteCredentialManager.stopBroadcasting()
    }
}

