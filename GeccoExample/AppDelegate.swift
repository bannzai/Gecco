//
//  AppDelegate.swift
//  GeccoExample
//
//  Created by yukiasai on 2016/01/15.
//  Copyright (c) 2016 yukiasai. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    fileprivate func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [AnyHashable: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }
}

