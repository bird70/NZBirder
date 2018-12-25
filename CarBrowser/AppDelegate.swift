////
////  AppDelegate.swift
////  NZBirder
////
////  Created by Tilmann Steinmetz on 23/12/18.
////  Copyright © 2018 Acme. All rights reserved.
////
//
//import Foundation
//import AVFoundation
//import UIKit
//
//@UIApplicationMain
//
//
//class AppDelegate : UIResponder, UIApplicationDelegate {
//    
//    var window: UIWindow?
//    
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        let navBackgroundImage = UIImage(named: "navbar_bg")
//        
//        window = UIWindow(frame: UIScreen.main.bounds)
//        UINavigationBar.appearance().setBackgroundImage(navBackgroundImage, for: .default)
//        
//        let shadow = NSShadow()
//        shadow.shadowColor = UIColor(white: 0.0, alpha: 0.80)
//        shadow.shadowOffset = CGSize(width: 0.0, height: 1.0)
//        
//        if let aSize = UIFont(name: "HelveticaNeue-CondensedBlack", size: 21.0) {
//            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 245.0 / 255.0, green: 245.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0), NSAttributedString.Key.shadow: shadow, NSAttributedString.Key.font: aSize]
//        }
//        // Change the appearance of back button
//        let backButtonImage = UIImage(named: "button_back")?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 13, 0, 6))
//        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backButtonImage, for: .normal, barMetrics: .default)
//        
//        // Change the appearance of other navigation button
//        let barButtonImage = UIImage(named: "button_normal")?.resizableImage(withCapInsets: UIEdgeInsetsMake(0, 6, 0, 6))
//        UIBarButtonItem.appearance().setBackgroundImage(barButtonImage, for: .normal, barMetrics: .default)
//        
//        let tabBarBackground = UIImage(named: "tabbar.png")
//        UITabBar.appearance().backgroundImage = tabBarBackground
//        UITabBar.appearance().selectionIndicatorImage = UIImage(named: "tabbar_selected.png")
//        
//        let sb = UIStoryboard(name: "MainStoryboard", bundle: nil)
//        let initialViewController = sb.instantiateInitialViewController(withIdentifier:"TabBarController")
//        
//        window?.rootViewController = initialViewController
//        window?.makeKeyAndVisible()
//        
//        // Assign tab bar item with titles
//        //let tabBarController = window.rootViewController as? UITabBarController
//        return YES;
//        
//        return YES;
//    }
//}
//
//func applicationWillResignActive(_ application: UIApplication) {
//}
//
//func applicationDidEnterBackground(_ application: UIApplication) {
//    ModelController.shared().saveContext()
//}
//
//func applicationWillEnterForeground(_ application: UIApplication) {
//}
//
//func applicationDidBecomeActive(_ application: UIApplication) {
//}
//
//func applicationWillTerminate(_ application: UIApplication) {
//    ModelController.shared().saveContext()
//}
//
//func applicationDidFinishLaunching(_ application: UIApplication) {
//    
//    AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, error: nil)
//}
//
//
