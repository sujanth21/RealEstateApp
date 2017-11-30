//
//  AppDelegate.swift
//  RealEstateApp
//
//  Created by Sujanth Sebamalaithasan on 27/11/17.
//  Copyright © 2017 Sujanth Sebamalaithasan. All rights reserved.
//

import UIKit
import Firebase
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let APP_ID = "7E87684B-9D11-4F8D-FF12-B322FC488800"
    let API_KEY = "3CE86AD7-B987-5985-FF40-40B80CBBB500"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        FirebaseApp.configure()
        backendless!.initApp(APP_ID, apiKey: API_KEY)
        
        OneSignal.initWithLaunchOptions(launchOptions, appId: kONESIGNALAPPID, handleNotificationReceived: nil, handleNotificationAction: nil, settings: nil)
        
        if #available(iOS 10.0, *) {
            
            let center = UNUserNotificationCenter.current()
            
            center.requestAuthorization(options: [.badge, .alert, .sound], completionHandler: { (granted, error) in
                
                
            })
            
            application.registerForRemoteNotifications()
        }
        
        return true
    }

    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
        
        //.sandbox
        
        //.production
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        
        //This is not firebase notification
        
    }


    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("Failed to register for user notifications")
    }
}

