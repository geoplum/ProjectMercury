//
//  AppDelegate.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 12/12/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let deepLinkHandler: DeepLinkHandler
    let remoteNotificationConfigurator: RemoteNotificationsConfigurator
    let router: RootRouter
    
    var configurators: [AppDelegateConfigurable] {
        return [
            remoteNotificationConfigurator,
            AppUIConfigurator(),
            router
        ]
    }
    
    fileprivate var urlHandlers: [AppDelegateURLHandleable] {
        return [deepLinkHandler]
    }

    fileprivate var linkHandlers: [AppDelegateURLHandleable] {
        return [deepLinkHandler]
    }
    
    var stateHandlers: [AppDelegateStateTransitionable] {
        return [remoteNotificationConfigurator]
    }
    
    override init() {
        deepLinkHandler = DeepLinkHandler()
        router = RootRouter(with: deepLinkHandler)
        remoteNotificationConfigurator = RemoteNotificationsConfigurator(router: router)
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return urlHandlers.contains { $0.application(app, open: url, options: options) }
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return linkHandlers.contains { $0.application(continue: userActivity, with: restorationHandler) }
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        deepLinkHandler.handle(shortcutItem, completionHandler: completionHandler)
    }
    
}

// MARK: - Push notifications

extension AppDelegate {

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        remoteNotificationConfigurator.didRegisterForRemoteNotifications(with: deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        remoteNotificationConfigurator.didFailToRegisterForRemoteNotifications(with: error)
    }
}
