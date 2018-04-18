//
//  ViewController.swift
//  MedableSandbox
//
//  Created by Rashad Abdul-Salam on 4/18/18.
//  Copyright © 2018 University of Pennsylvania Health System. All rights reserved.
//

import UIKit
import zxcvbn_ios

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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func submitPressed(_ sender: UIBarButtonItem) {
        Medable.client().registerAccount(withFirstName: "", lastName: "", email: "", mobile: "", password: "", gender: nil, dob: nil, role: nil, profileInfo: nil, thumbImage: nil, timeZone: nil, customPropValues: nil) { (account, error) in
            //
        }
    }
    
}

extension RegistrationTableViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let password = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        self.passwordStrengthMeter.scorePassword(password)
        return true
    }
}

