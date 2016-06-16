//
//  AppDelegate.swift
//  DBFM
//
//  Created by Jet on 16/6/11.
//  Copyright © 2016年 Jet. All rights reserved.
//

import UIKit
import SDWebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        SDWebImageManager.sharedManager().cancelAll()
        SDWebImageManager.sharedManager().imageCache.clearDisk()
    }
}

