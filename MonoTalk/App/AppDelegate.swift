//
//  AppDelegate.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/10/30.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import RealmSwift
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        configureRootViewController()

        // Load seed data when first launch
        let userDefault = UserDefaults.standard
        let dict = ["firstLaunch": true]
        userDefault.register(defaults: dict)
        if userDefault.bool(forKey: "firstLaunch") {
            RealmInitializer.setup()
            userDefault.set(false, forKey: "firstLaunch")
        }

        setNaviBarStyle()
        
        sleep(1); // to prevent the splash screen disappear too fast
        return true
    }
    
    private func configureRootViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "CategoryTableView")
        
        navigationController = UINavigationController(rootViewController: viewController)
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }

    func setNaviBarStyle() {
        // Color
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = MyColor.theme.value
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: MyColor.darkText.value]

        // Border
        UINavigationBar.appearance().shadowImage = MyColor.border.value.as1ptImage()

        // Back button icon
        let backIcon = UIImage(named: "navi_back")
        UINavigationBar.appearance().backIndicatorImage = backIcon
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backIcon

    }

}

