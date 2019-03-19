//
//  AppDelegate.swift
//  Chatter
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        SocketService.instance.establishConnection()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        SocketService.instance.closeConnection()
    }
}
