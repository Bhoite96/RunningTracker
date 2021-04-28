//
//  View1Controller.swift
//  BackToGoal
//
//  Created by Apurva Bhoite on 4/26/21.
//


import UIKit
import Firebase
import SwiftSpinner

class View1Controller: UIViewController {

    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblStatus: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStatus.text = ""
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let keyChain = KeychainService().keyChain
        
        if keyChain.get("uid") != nil {
            // User has already logged in
            //perform segue
            performSegue(withIdentifier: "dashboard", sender: self)
        }
        txtPassword.text = ""
    }

    func addKeychainAfterLogin(_ uid : String ){
        let keyChain = KeychainService().keyChain
        keyChain.set(uid, forKey: "uid")
    }
    
    
    @IBAction func loginAction(_ sender: Any) {
        
        let email = txtEmail.text!
        let password = txtPassword.text!
        
        if email == "" || password == "" || password.count < 6 {
            lblStatus.text = "Please enter valid email/password"
            return
        }
        if email.isEmail == false {
            lblStatus.text = "Please enter valid Email"
            return
        }
        
        SwiftSpinner.show("Logging In ")
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            SwiftSpinner.hide()
          guard let self = self else { return }
        
            if error != nil {
                self.lblStatus.text = error?.localizedDescription
                return
            }
            //we are logged in at this point
            
          //  let storyboard = self.storyboard?.instantiateViewController(identifier:"DashboardViewController") as DashboardViewController?
          //  self.navigationController?.pushViewController(storyboard!, animated: true)
            
            let uid = Auth.auth().currentUser?.uid
            
            self.addKeychainAfterLogin(uid!)
            
            self.performSegue(withIdentifier: "dashboard", sender: self)
            
        }
    }
    
}
