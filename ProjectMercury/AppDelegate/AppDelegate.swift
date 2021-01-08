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
        
        configurators.forEach { (configurator) in
            configurator.configure(application: application, launchOptions: launchOptions)
        }
        
        return true
    }
    
    // MARK: - App Lifecycle
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        stateHandlers.forEach { $0.didEnterBackground(application) }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication)
    {
        stateHandlers.forEach { $0.willEnterForeground(application) }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {
        stateHandlers.forEach { $0.didBecomeActive(application) }
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
