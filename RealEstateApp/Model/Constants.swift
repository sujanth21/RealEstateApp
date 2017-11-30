//
//  Constants.swift
//  RealEstateApp
//
//  Created by Sujanth Sebamalaithasan on 28/11/17.
//  Copyright © 2017 Sujanth Sebamalaithasan. All rights reserved.
//

import Foundation
import Firebase

var backendless = Backendless.sharedInstance()
var firebase = Database.database().reference()

//IDs and Keys
public let kONESIGNALAPPID = ""

//Firebase User
public let kOBJECTID = "objectId"
public let kUSER = "User"
public let kCREATEDAT = "createdAt"
public let kUPDATEDAT = "updatedAt"
public let kCOMPANY = "company"
public let kPHONE = "phone"
public let kADDPHONE = "addPhone"

public let kCOINS = "coins"
public let kPUSHID = "pushId"
public let kFIRSTNAME = "firstname"
public let kLASTNAME = "lastname"
public let kFULLNAME = "fullname"
public let kAVATAR = "avatar"
public let kCURRESNTUSER = "currentUser"
public let kISONLINE = "isOnline"
public let kVERIFICATIONCODE = "firebase_verification"
public let kISAGENT = "isAgent"
public let kFAVORITE = "favoriteProperties"

//Property
public let kMAXIMAGENUMBER = 10
public let kRECENTPROPERTYLIMIT = 20

//FB Notification
public let kFBNOTIFICATIONS = "Notifications"
public let kNOTIFICATIONID = "notificationId"
public let kPROPERTYREFERENCEID = "referenceId"
public let kPROPERTYOBJECTID = "propertyObjectId"
public let kBUYERFULLNAME = "buyerFullname"
public let kBUYERID = "buyerId"
public let kAGENTID = "agentId"

//Push
public let kDEVICEID = "deviceId"

//Other
public let kTEMPFAVORITEID = "tempId"
