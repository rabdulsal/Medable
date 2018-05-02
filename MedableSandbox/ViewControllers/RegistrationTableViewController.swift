//
//  ViewController.swift
//  MedableSandbox
//
//  Created by Rashad Abdul-Salam on 4/18/18.
//  Copyright © 2018 University of Pennsylvania Health System. All rights reserved.
//

import UIKit
import zxcvbn_ios
import libPhoneNumber_iOS

class RegistrationTableViewController: UITableViewController {
    
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailAddressField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var mobileNumberField: UITextField!
    @IBOutlet weak var passwordStrengthMeter: DBPasswordStrengthMeterView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.passwordField.delegate = self
        self.title = "Registration"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitPressed(_ sender: UIBarButtonItem) {
        
        if DBZxcvbn().passwordStrength(passwordField.text!).score < 2 {
            print("The password is not strong enough")
            return
        }
        
        let phoneUtil = NBPhoneNumberUtil()
        do {
            let myNumber = try phoneUtil.parse(mobileNumberField.text!, defaultRegion: "US")
            if !phoneUtil.isValidNumber(myNumber) {
                return
            }
        } catch let error as NSError {
            print(error)
        }
        
        self.register()
    }
}

extension RegistrationTableViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let password = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        self.passwordStrengthMeter.scorePassword(password)
        return true
    }
}

private extension RegistrationTableViewController {
    
    func register() {
        Medable.client().registerAccount(
            withFirstName: self.firstNameField.text!,
            lastName: self.lastNameField.text!,
            email: self.emailAddressField.text!,
            mobile: self.mobileNumberField.text!,
            password: self.passwordField.text!,
            gender: nil,
            dob: nil,
            role: nil,
            profileInfo: nil,
            thumbImage: nil,
            timeZone: nil,
            customPropValues: nil) { (account, error) in
                print("Callback returns account: \(account)")
                print("Callback returns error: \(error)")
        }
    }
}

