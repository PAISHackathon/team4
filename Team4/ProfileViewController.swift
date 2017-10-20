//
//  ProfileViewController.swift
//  Team4
//
//  Created by Julien Cayzac on 10/20/17.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.handleNotification(_:)), name: LocalCredentialManager.kLoggedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.handleNotification(_:)), name: LocalCredentialManager.kLoggedOut, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleNotification(_ notification:Notification) {
        updateDisplay()
    }
    
    fileprivate func updateDisplay() {
        if let user = LocalCredentialManager.shared.loadUser() {
            usernameLabel.text = user.username
            loginButton.setTitle("logout", for: .normal)
        } else {
            usernameLabel.text = "-"
            loginButton.setTitle("login", for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateDisplay()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

