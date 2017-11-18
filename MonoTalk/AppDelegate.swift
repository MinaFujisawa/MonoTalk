 //
//  AppDelegate.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/10/30.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        

        let userDefault = UserDefaults.standard
        let dict = ["firstLaunch": true]
        userDefault.register(defaults: dict)
        if userDefault.bool(forKey: "firstLaunch") {
            RealmInitializer.setUp()
            userDefault.set(false, forKey: "firstLaunch")
        }
        
        setNaviBarStyle()
        return true
    }
    
    func setNaviBarStyle() {
        // Color
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = MyColor.darkText.value
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: MyColor.darkText.value]
        
        // Border
        UINavigationBar.appearance().shadowImage = MyColor.border.value.as1ptImage()
        
        // Back button icon
        let backIcon = UIImage(named: "navi_back")
        UINavigationBar.appearance().backIndicatorImage = backIcon
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backIcon
        
        
        // Back position
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(2, 0), for: UIBarMetrics.default)
    }

}

