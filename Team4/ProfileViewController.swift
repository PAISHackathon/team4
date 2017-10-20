//
//  ProfileViewController.swift
//  Team4
//
//  Created by Julien Cayzac on 10/20/17.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var topTextLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotification(_:)), name: .loggedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleNotification(_:)), name: .loggedOut, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleNotification(_ notification:Notification) {
        updateDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateDisplay()
    }

    fileprivate func updateDisplay() {
        if let user = LocalCredentialManager.shared.loadUser() {
            topTextLabel.text = "Welcome back, \(user.username)!"
            loginButton.setTitle("logout", for: .normal)
        } else {
            topTextLabel.text = "Tap the button below to login"
            loginButton.setTitle("login", for: .normal)
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "loginSegue" {
            if LocalCredentialManager.shared.loadUser() != nil {
                LocalCredentialManager.shared.removeCredential()
                return false
            }
        }
        return true
    }
}

