//
//  LoginViewController.swift
//  Team4
//
//  Created by Guo, Li on 2017/10/20.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordFiled: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginRemoteButton: UIButton!

    override func viewDidLoad() {
        loginRemoteButton.isEnabled = false

        NotificationCenter.default.addObserver(self, selector: #selector(self.onCredentialServersFound), name: .credentialServersFound, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.onCredentialServersNotFound), name: .credentialServersNotFound, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.onCredentialAcquired(_:)), name: .credentialAcquired, object: nil);
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.shared.remoteCredentialManager.startListening()
    }

    override func viewDidDisappear(_ animated: Bool) {
        AppDelegate.shared.remoteCredentialManager.stopListening()
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let username = usernameField.text, let password = passwordFiled.text
        else {
            return
        }

        login(UserCredential(username: username, password: password))
    }
    
    @IBAction func loginRemoteButtonTapped(_ sender: Any) {
        AppDelegate.shared.remoteCredentialManager.requestCredential()
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func login(_ credential: UserCredential!) {
        LocalCredentialManager.shared.saveUserCredential(credential)
        dismiss(animated: true, completion: nil)
    }

    @objc func onCredentialServersFound() {
        loginRemoteButton.isEnabled = true
        loginRemoteButton.backgroundColor = UIColor(red: 0.3412, green: 0.6235, blue: 0.1686, alpha: 1)
    }

    @objc func onCredentialServersNotFound() {
        loginRemoteButton.isEnabled = false
        loginRemoteButton.backgroundColor = UIColor(white: 0.33333, alpha: 1)
    }

    @objc func onCredentialAcquired(_ notification: Notification!) {
        login(notification.object as! UserCredential)
    }
}
