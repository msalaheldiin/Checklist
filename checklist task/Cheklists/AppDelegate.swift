//
//  AppDelegate.swift
//  Cheklists
//  Copyright © 2018 Mahmoud. All rights reserved.
 

import UIKit
import UserNotifications
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?
    let dataModel = DataModel()
    func applicationDidEnterBackground(_ application: UIApplication) {
    saveData()
    }
    func applicationWillTerminate(_ application: UIApplication) {
        saveData()
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        let navigationController = window!.rootViewController as! UINavigationController
        let controller = navigationController.viewControllers[0] as! AllListsViewController
        controller.dataModel = dataModel
        

        
        return true
    }
    func saveData() {
//        let navigationController = window!.rootViewController   as! UINavigationController
//        let controller = navigationController.viewControllers[0]as! AllListsViewController
//        controller.saveChecklists()
        dataModel.saveChecklists()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,willPresent notification: UNNotification,withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Received local notification \(notification)")
    }
}

