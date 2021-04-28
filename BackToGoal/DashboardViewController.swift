//
//  DashboardViewController.swift
//  BackToGoal
//
//  Created by Apurva Bhoite on 4/26/21.
//


import UIKit
import Firebase

class DashboardViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view
        self.navigationItem.hidesBackButton = true
    }
    
    @IBAction func logoutAction(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
            KeychainService().keyChain.delete("uid")
            self.navigationController?.popViewController(animated: true)
            
        } catch {
            print (error)
        }
    }
}
