//
//  AppDelegate.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 12/12/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Internal properties
    
    internal var window: UIWindow?
    
    // MARK: - private properties
    
    private let deepLinkHandler: DeepLinkHandler
    private let remoteNotificationConfigurator: RemoteNotificationsConfigurator
    private let router: RootRouter
    
    fileprivate var configurators: [AppDelegateConfigurable] {
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
    
    fileprivate var stateHandlers: [AppDelegateStateTransitionable] {
        return [remoteNotificationConfigurator]
    }
    
    override init() {
        deepLinkHandler = DeepLinkHandler()
        router = RootRouter(with: deepLinkHandler)
        remoteNotificationConfigurator = RemoteNotificationsConfigurator(router: router)
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        configurators.forEach { (configurator) in
            configurator.configure(application: application, launchOptions: launchOptions)
        }
        
        return true
    }
    
    // MARK: - App Lifecycle
    
    func applicationWillResignActive(_ application: UIApplication)
    {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        stateHandlers.forEach { $0.didEnterBackground(application) }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication)
    {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        stateHandlers.forEach { $0.willEnterForeground(application) }
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        stateHandlers.forEach { $0.didBecomeActive(application) }
    }
        
    func applicationWillTerminate(_ application: UIApplication)
    {
        
    }
}

// MARK: - URL Handler

extension AppDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        return urlHandlers.contains { $0.application(app, open: url, options: options) }
    }
}

// MARK: - Link Handler

extension AppDelegate {
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return linkHandlers.contains { $0.application(continue: userActivity, with: restorationHandler) }
    }
}

// MARK: - Deeplinks

extension AppDelegate {
    
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
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
//    {
//
//    }
}
