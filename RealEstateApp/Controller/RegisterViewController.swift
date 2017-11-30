//
//  RegisterViewController.swift
//  RealEstateApp
//
//  Created by Sujanth Sebamalaithasan on 29/11/17.
//  Copyright © 2017 Sujanth Sebamalaithasan. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    //Phone register outlets
    @IBOutlet weak var phoneNumberTxtFld: UITextField!
    @IBOutlet weak var codeTxtFld: UITextField!
    @IBOutlet weak var requestCodeBtn: RoundedCornerButton!
    
    //Email register outlets
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var firstNameTxtFld: UITextField!
    @IBOutlet weak var lastNameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    
    var phoneNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- IBActions
    
    @IBAction func requestCodeBtnPressed(_ sender: Any) {
        
        if phoneNumberTxtFld.text != nil {
            
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumberTxtFld.text!, uiDelegate: nil, completion: { (verficationId, error) in
                
                if error != nil {
                    print("Error phone number \(error?.localizedDescription)")
                    return
                }
                
                self.phoneNumber = self.phoneNumberTxtFld.text!
                self.phoneNumberTxtFld.text = ""
                self.phoneNumberTxtFld.placeholder = self.phoneNumber!
                
                self.phoneNumberTxtFld.isEnabled = false
                self.codeTxtFld.isHidden = false
                self.requestCodeBtn.setTitle("Register", for: .normal)
                
                UserDefaults.standard.set(verficationId, forKey: kVERIFICATIONCODE)
                UserDefaults.standard.synchronize()
            })
        }
        
        if codeTxtFld.text != "" {
            
            FirebaseUser.registerUserWith(phoneNumber: phoneNumber!, verificationCode: codeTxtFld.text!, completion: { (error, shouldLogin) in
                
                if error != nil {
                    print("Error \(error?.localizedDescription)")
                    return
                }
                
                if shouldLogin {
                    // Go to main view
                    
                } else {
                    // Go to finish register view
                }
            })
        }
    }
    
    
    @IBAction func registerEmailBtnPressed(_ sender: Any) {
        
        if emailTxtFld.text != "" && passwordTxtFld.text != "" && firstNameTxtFld.text != "" && lastNameTxtFld.text != "" {
            
            FirebaseUser.registerUserWith(email: emailTxtFld.text!, password: passwordTxtFld.text!, firstName: firstNameTxtFld.text!, lastName: lastNameTxtFld.text!, completion: { (error) in
                
                if error != nil {
                    print("Email registering error: \(String(describing: error?.localizedDescription))")
                }
                
                self.goToMainView()
            })
        }
    }
    

    @IBAction func closeBtnPressed(_ sender: Any) {
        
        goToMainView()
    }
    
    func goToMainView() {
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC") as! UITabBarController
        
        self.present(mainView, animated: true, completion: nil)
    }
    

}
