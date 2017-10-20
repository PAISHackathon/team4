//
//  LocalCredentialManager.swift
//  Team4
//
//  Created by Guo, Li on 2017/10/20.
//

import Foundation

struct UserCredential: Codable {
    var username:String
    var password:String
}

extension Notification.Name {
    static let loggedIn = Notification.Name("loggedIn")
    static let loggedOut = Notification.Name("loggedOut")
}


class LocalCredentialManager {
    static let shared = LocalCredentialManager()
    private let kUsername = "username"
    private let kPassword = "password"
    
    func saveUserCredential(_ credential:UserCredential) {
        UserDefaults.standard.set(credential.username, forKey: kUsername)
        UserDefaults.standard.set(credential.password, forKey: kPassword)

        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .loggedIn, object: credential)
        }
    }
    
    func loadUser() -> UserCredential? {
        if let username = UserDefaults.standard.string(forKey: kUsername),
            let password = UserDefaults.standard.string(forKey: kPassword) {
            return UserCredential(username: username, password: password)
        } else {
            return nil
        }
    }
    
    func removeCredential() {
        UserDefaults.standard.removeObject(forKey: kUsername)
        UserDefaults.standard.removeObject(forKey: kPassword)

        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .loggedOut, object: nil)
        }
    }
}
