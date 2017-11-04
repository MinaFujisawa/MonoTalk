//
//  AppDelegate.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/10/30.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        MyRealm.resetRealm()
        
        // Check if user opens the app for very first time
        let userDefault = UserDefaults.standard
        let dict = ["firstLaunch": true]
        userDefault.register(defaults: dict)
        if userDefault.bool(forKey: "firstLaunch") {
            RealmInitializer.setUp()
            userDefault.set(false, forKey: "firstLaunch")
        }
        
        // for debug
//        userDefault.set(true, forKey: "firstLaunch")
//        MyRealm.resetRealm()
        
        return true
    }

}

