//
//  FirebaseUser.swift
//  RealEstateApp
//
//  Created by Sujanth Sebamalaithasan on 29/11/17.
//  Copyright © 2017 Sujanth Sebamalaithasan. All rights reserved.
//

import Foundation
import Firebase

class FirebaseUser {
    
    let objectId: String
    var pushId: String?
    
    let createdAt: Date
    var updatedAt: Date
    
    var coins: Int
    var companyName: String
    var firstName: String
    var lastName: String
    var fullName: String
    var avatar: String
    var phoneNumber: String
    var additionalPhoneNumber: String
    var isAgent: Bool
    var favoriteProperties: [String]
    
    init(objectId: String, pushId: String?, createdAt: Date, updatedAt: Date, firstName: String, lastName: String, avatar: String = "", phoneNumber: String = "") {
        
        self.objectId = objectId
        self.pushId = pushId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.coins = 10
        self.companyName = ""
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = firstName + " " + lastName
        self.avatar = avatar
        self.phoneNumber = phoneNumber
        self.additionalPhoneNumber = ""
        self.isAgent = false
        self.favoriteProperties = []
    }
    
    init(dictionary: NSDictionary) {
        
        self.objectId = dictionary[kOBJECTID] as! String
        self.pushId = dictionary[kPUSHID] as? String
        
        if let created = dictionary[kCREATEDAT] {
            self.createdAt = dateFormatter().date(from: created as! String)!
        } else {
            self.createdAt = Date()
        }
        
        if let updated = dictionary[kUPDATEDAT] {
            self.updatedAt = dateFormatter().date(from: updated as! String)!
        } else {
            self.updatedAt = Date()
        }
        
        if let dCoin = dictionary[kCOINS] {
            self.coins = dCoin as! Int
        } else {
            self.coins = 0
        }
        
        if let company = dictionary[kCOMPANY] {
            self.companyName = company as! String
        } else {
            self.companyName = ""
        }
        
        if let fName = dictionary[kFIRSTNAME] {
            self.firstName = fName as! String
        } else {
            self.firstName = ""
        }
        
        if let lName = dictionary[kLASTNAME] {
            self.lastName = lName as! String
        } else {
            self.lastName = ""
        }
        
        self.fullName = firstName + " " + lastName
        
        if let avatar = dictionary[kAVATAR] {
            self.avatar = avatar as! String
        } else {
            self.avatar = ""
        }
        
        if let agent = dictionary[kISAGENT] {
            self.isAgent = agent as! Bool
        } else {
            self.isAgent = false
        }
        
        if let phoneNumber = dictionary[kPHONE] {
            self.phoneNumber = phoneNumber as! String
        } else {
            self.phoneNumber = ""
        }
        
        if let addPhone = dictionary[kADDPHONE] {
            self.additionalPhoneNumber = addPhone as! String
        } else {
            self.additionalPhoneNumber = ""
        }
        
        if let favProp = dictionary[kFAVORITE] {
            self.favoriteProperties = favProp as! [String]
        } else {
            self.favoriteProperties = []
        }
    }
    
    
    class func currentId() -> String {
        
        return Auth.auth().currentUser!.uid
    }
    
    class func currentUser() -> FirebaseUser? {
        
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: kCURRESNTUSER) {
                return FirebaseUser.init(dictionary: dictionary as! NSDictionary)
            }
        }
        return nil
    }
    
    //Registering user using email and password
    class func registerUserWith(email: String, password: String, firstName: String, lastName: String, completion: @escaping(_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (firUser, error) in
            
            if error != nil {
                completion(error)
                return
            }
            
            let fUser = FirebaseUser(objectId: firUser!.uid, pushId: "", createdAt: Date(), updatedAt: Date(), firstName: firstName, lastName: lastName)
            
            //Save to user defaults
            saveUserLocally(fUser: fUser)
            
            //Save to firebase
            saveUserInBackground(fUser: fUser)
            
            completion(error)
        }
    }
    
    //Registering user using phone number
    class func registerUserWith(phoneNumber: String, verificationCode: String, completion: @escaping(_ error: Error?, _ shouldLogin: Bool) -> Void) {
        
        let verificationID = UserDefaults.standard.value(forKey: kVERIFICATIONCODE)
        
        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verificationID as! String, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credentials) { (firUser, error) in
            
            if error != nil {
                completion(error!, false)
                return
            }
            
            fetchUserWith(userId: firUser!.uid, completion: { (user) in
                
                if user != nil && user!.firstName != "" {
                    
                    //User already exist so log in
                    saveUserLocally(fUser: user!)
                    completion(error, true)
                } else {
                    
                    //User is not exist so register the user
                    let fUser = FirebaseUser(objectId: firUser!.uid, pushId: "", createdAt: Date(), updatedAt: Date(), firstName: "", lastName: "", phoneNumber: firUser!.phoneNumber!)
                    
                    saveUserLocally(fUser: fUser)
                    saveUserInBackground(fUser: fUser)
                    completion(error, false)
                }
            })
        }
    }
    
}

//MARK:- Saving User
func saveUserLocally(fUser: FirebaseUser) {
    
    UserDefaults.standard.set(userDictionaryFrom(user: fUser), forKey: kCURRESNTUSER)
    UserDefaults.standard.synchronize()
}

func saveUserInBackground(fUser: FirebaseUser) {
    
    let ref = firebase.child(kUSER).child(fUser.objectId)
    ref.setValue(userDictionaryFrom(user: fUser))
}

//MARK:- Helper functions
func userDictionaryFrom(user: FirebaseUser) -> NSDictionary {
    
    let createdAt = dateFormatter().string(from: user.createdAt)
    let updatedAt = dateFormatter().string(from: user.updatedAt)
    
    return NSDictionary(objects: [user.objectId, createdAt, updatedAt, user.companyName, user.pushId!, user.firstName, user.lastName, user.fullName, user.avatar, user.phoneNumber, user.additionalPhoneNumber, user.isAgent, user.coins, user.favoriteProperties], forKeys: [kOBJECTID as NSCopying, kCREATEDAT as NSCopying, kUPDATEDAT as NSCopying, kCOMPANY as NSCopying, kPUSHID as NSCopying, kFIRSTNAME as NSCopying, kLASTNAME as NSCopying, kFULLNAME as NSCopying, kAVATAR as NSCopying, kPHONE as NSCopying, kADDPHONE as NSCopying, kISAGENT as NSCopying, kCOINS as NSCopying, kFAVORITE as NSCopying])
}

func fetchUserWith(userId: String, completion: @escaping(_ user: FirebaseUser?) -> Void) {
    
    firebase.child(kUSER).queryOrdered(byChild: kOBJECTID).queryEqual(toValue: userId).observeSingleEvent(of: .value) { (snapshot) in
        
        if snapshot.exists() {
            
            let userDictionary = ((snapshot.value as! NSDictionary).allValues as NSArray).firstObject! as! NSDictionary
            
            let user = FirebaseUser(dictionary: userDictionary)
            completion(user)
        } else {
            completion(nil)
        }
    }
}
