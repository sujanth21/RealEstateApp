//
//  RegisterViewController.swift
//  RealEstateApp
//
//  Created by Sujanth Sebamalaithasan on 29/11/17.
//  Copyright © 2017 Sujanth Sebamalaithasan. All rights reserved.
//

import UIKit

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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //MARK:- IBActions
    
    @IBAction func requestCodeBtnPressed(_ sender: Any) {
    }
    
    
    @IBAction func registerEmailBtnPressed(_ sender: Any) {
    }
    

    @IBAction func closeBtnPressed(_ sender: Any) {
        
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainVC") as! UITabBarController
        
        self.present(mainView, animated: true, completion: nil)
    }
    

}
