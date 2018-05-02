//
//  LoginTableViewController.swift
//  MedableSandbox
//
//  Created by Rashad Abdul-Salam on 4/24/18.
//  Copyright © 2018 University of Pennsylvania Health System. All rights reserved.
//

import Foundation
import CareKit

class LoginTableViewController : UITableViewController {
    
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var verificationCodeController : UIAlertController {
        let verifyController = UIAlertController(
            title: "Verification Code",
            message: "Enter the 6-digit code that was sent to your mobile device",
            preferredStyle: .alert)
        verifyController.addTextField { (textField:UITextField) in
            textField.keyboardType = .numberPad
        }
        verifyController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil))
        verifyController.addAction(UIAlertAction(
            title: "Submit",
            style: .default,
            handler: { (action:UIAlertAction) in
            if let verificationCode = verifyController.textFields?.first?.text {
                self.login(verificationCode: verificationCode)
            }
        }))
        return verifyController
    }
    
    var passwordResetController : UIAlertController {
        let passwordController = UIAlertController(
            title: "Password Reset",
            message: "Enter the email address you used to register and we'll email you a password reset link.",
            preferredStyle: .alert)
        passwordController.addTextField { (textField:UITextField) in
            textField.keyboardType = .emailAddress
        }
        passwordController.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil))
        passwordController.addAction(UIAlertAction(
            title: "Submit",
            style: .default,
            handler: { (action:UIAlertAction) in
            if let email = self.passwordResetController.textFields?.first?.text {
                Medable.client().requestPasswordReset(withEmail: email, callback: { (error:MDFault) in } as! MDFaultCallback)
            }
        }))
        return passwordController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Login"
//        self.showCareCard()
    }
    
    @IBAction func submitPressed(_ sender: UIBarButtonItem) {
        self.login()
    }
    
    @IBAction func passwordResetPressed(_ sender: UIBarButtonItem) {
        self.present(self.passwordResetController, animated: true, completion: nil)
    }
    
}

private extension LoginTableViewController {
    
    func login(verificationCode: String?=nil) {
        Medable.client().login(
            withEmail: self.emailAddressField.text!,
            password: self.passwordField.text!,
            verificationToken: verificationCode,
            singleUse: false) { (account, error) in
                
                print("Callback returns account: \(account)")
                print("Callback returns error: \(error)")
                
                if error == nil {
                    // TODO: Refactor to include TabBarController instantiation
//                    let activity = ActivityService()
//                    activity.addIbuprofenActivity()
                    
//                    let viewController = OCKCareCardViewController(carePlanStore: activity.carePlanStoreManager.store)
//                    let navController = UINavigationController(rootViewController: viewController)
//
//                    self.present(navController, animated: true, completion: nil)
                }
                
        }
    }
    
    func showCareCard() {
        // TODO: Refactor to include TabBarController instantiation
//        let activity = ActivityService()
//        activity.addIbuprofenActivity()
//        activity.makeActivities()
//        let viewController = OCKCareCardViewController(carePlanStore: activity.carePlanStoreManager.store)
//        let navController = UINavigationController(rootViewController: viewController)
//
//        self.present(navController, animated: true, completion: nil)
    }
}
