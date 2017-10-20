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

class LocalCredentialManager {
    static let shared = LocalCredentialManager()
    static let kLoggedIn = Notification.Name(rawValue:"LocalCredentialManagerLoggedIn")
    static let kLoggedOut = Notification.Name(rawValue:"LocalCredentialManagerLoggedOut")
    private let kUsername = "username"
    private let kPassword = "password"
    
    func saveUserCredential(_ credential:UserCredential) {
        UserDefaults.standard.set(credential.username, forKey: kUsername)
        UserDefaults.standard.set(credential.password, forKey: kPassword)
        NotificationCenter.default.post(name: LocalCredentialManager.kLoggedIn, object: nil)
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
        NotificationCenter.default.post(name: LocalCredentialManager.kLoggedOut, object: nil)
    }
}
