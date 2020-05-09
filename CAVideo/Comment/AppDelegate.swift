//
//  AppDelegate.swift
//  CAVideo
//
//  Created by Cary on 2019/8/28.
//  Copyright © 2019 Cary. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // 键盘处理
        setupKeyboard()
        //创建tabbar
        setupTabbar()
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal:-200,vertical:0), for: .default)
        UINavigationBar.appearance().tintColor = UIColor.white
        return true
    }
    
    func setupKeyboard() {
    
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "完成"
        IQKeyboardManager.shared.toolbarTintColor = UIColor(hex: "#333333")  
    }
    
    func setupTabbar() {
        
        let vc1 = RecommendVC()
        vc1.tabBarItem =  UITabBarItem(title:"推荐", image: UIImage(named: "recommend"), selectedImage: UIImage(named:"recommend_selected"))
        let nav1 = createNav(vc: vc1)
        
        let vc2 = TelevisionVC()
        vc2.tabBarItem =  UITabBarItem(title:"美剧", image: UIImage(named: "television"), selectedImage: UIImage(named:"television_selected"))
        let nav2 = createNav(vc: vc2)
        
        let vc3 = MovieVC()
        vc3.tabBarItem =  UITabBarItem(title:"电影", image: UIImage(named: "movie"), selectedImage: UIImage(named:"movie_selected"))
        let nav3 = createNav(vc: vc3)
        
        let tbcMain = UITabBarController()
        tbcMain.viewControllers = [nav1,nav2,nav3]
        tbcMain.tabBar.isTranslucent = false
        window?.rootViewController = tbcMain
    }
    
    func createNav (vc:UIViewController) ->UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        let dict:NSDictionary = [NSAttributedString.Key.foregroundColor: UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]
        nav.navigationBar.titleTextAttributes = dict as? [NSAttributedString.Key : AnyObject]
        nav.navigationBar.tintColor = UIColor.white
        nav.navigationBar.barTintColor = UIColor.navColor
        nav.navigationBar.isTranslucent = false
        return nav
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

