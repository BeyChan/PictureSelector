//
//  AppDelegate.swift
//  图片选择器
//
//  Created by Melody Chan on 16/6/29.
//  Copyright © 2016年 canlife. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        window?.rootViewController = MYPhotoSelectorViewController()
        window?.makeKeyAndVisible()
        // Override point for customization after application launch.
        return true
    }

}

