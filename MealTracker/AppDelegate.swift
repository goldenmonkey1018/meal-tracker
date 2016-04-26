//
//  AppDelegate.swift
//  MealTracker
//
//  Created by Valti Skobo on 31/03/16.
//  Copyright © 2016 Valti Skobo. All rights reserved.
//

import UIKit

import Fabric
import Crashlytics

import Analytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let configuration = SEGAnalyticsConfiguration.init(writeKey: "bUCQtfmD2Pf5BHreqrBM08GV9OVr0Rwg")
        
        configuration.flushAt = 1
        SEGAnalytics.setupWithConfiguration(configuration)
        
        SEGAnalytics.sharedAnalytics().track("Rate Product111", properties: ["plan": "Enterprise"], options: ["integrations": ["All": true, "Maxpanel": false]])
        
        SEGAnalytics.sharedAnalytics().screen("Photo Feed", properties: ["Feed Type" : "public"])
        
        //SEGAnalytics.sharedAnalytics().alias("glenncoco")
        //SEGAnalytics.sharedAnalytics().flush()
        SEGAnalytics.debug(true)
        SEGAnalytics.sharedAnalytics().enable()
        //SEGAnalytics.sharedAnalytics().identify(nil, traits: ["email": "tom.charytoniuk@gmail.com", "Content":"Described here"])

        Fabric.with([Crashlytics.self])
        
        gPhotoObjArr = [PhotoObject]()
        
        //NSData *loginData = [[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentUser"];
        //_gCurrentUser = [NSKeyedUnarchiver unarchiveObjectWithData:loginData];
        
        if let arrayData = NSUserDefaults.standardUserDefaults().objectForKey("PhotoAlbum") as? NSData,
            photoArray = NSKeyedUnarchiver.unarchiveObjectWithData(arrayData) as? [PhotoObject] {
                gPhotoObjArr = photoArray
        } else {
            gPhotoObjArr = [PhotoObject]()
        }
        
        if let jsonData = NSUserDefaults.standardUserDefaults().objectForKey("ArrDescription") as? NSData,
            jsonArray = NSKeyedUnarchiver.unarchiveObjectWithData(jsonData) as? NSArray {
                gGetJSON = 1
                gArrDescription = jsonArray.mutableCopy() as! NSMutableArray
        }else {
            gArrDescription = NSMutableArray.init(capacity: 0)
        }
        
        if let readTerm = NSUserDefaults.standardUserDefaults().objectForKey("ReadTermAlready") as? NSData,
            readTermFlag = NSKeyedUnarchiver.unarchiveObjectWithData(readTerm) as? Int {
                gReadTermAlready = readTermFlag
                
                //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                
                let vc = storyboard.instantiateViewControllerWithIdentifier("vcSnapChatPageViewController") as? SnapChatPageViewController
                //vc?.delegate = AppDelegate().
                
                self.window?.rootViewController = vc;
        } else {
            gReadTermAlready = 0
        }

        return true
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

