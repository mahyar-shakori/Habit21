//
//  AppDelegate.swift
//  Habit21
//
//  Created by MahyarShakouri on 1/8/22.
//
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UITextField.appearance().tintColor = .label
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {success, error in
            if success{
                print("User gave permissions for local notifications")}
        }
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = UINavigationController()
        navigationController.isNavigationBarHidden = true
        
        if UserDefaults.standard.bool(forKey: "isLogin") {
            let rootViewController = storyboard.instantiateViewController(identifier:"Welcome") as UIViewController
            navigationController.viewControllers = [rootViewController]
            self.window?.rootViewController = navigationController
        }
        else {
            let rootViewController = storyboard.instantiateViewController(identifier:"Intro") as UIViewController
            navigationController.viewControllers = [rootViewController]
            self.window?.rootViewController = navigationController
        }
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
