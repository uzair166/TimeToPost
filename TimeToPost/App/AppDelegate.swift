//
//  AppDelegate.swift
//  TimeToPost
//
//  Created by Uzair Ishaq on 06/04/2019.
//  Copyright © 2019 Uzair Ishaq. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setAppearance()
        return true
    }

    // MARK: Setup Appearance
    
    private func setAppearance() {
        UITabBar.appearance().tintColor = UIColor.init(red: 233/255, green: 79/255, blue: 97/255, alpha: 1)
    }
}

