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
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let username = usernameField.text, let password = passwordFiled.text
            else{
                return
        }
        LocalCredentialManager.shared.saveUserCredential(UserCredential(username: username, password: password))
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginRemoteButtonTapped(_ sender: Any) {
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
