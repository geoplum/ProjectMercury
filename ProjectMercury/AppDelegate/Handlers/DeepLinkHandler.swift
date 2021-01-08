//
//  DeepLinkHandler.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 13/12/2020.
//

import UIKit
import Foundation

// MARK: -

final class DeepLinkHandler: AppDelegateURLHandleable {
    
    // MARK: - Properties
    
    weak var router: NavigationRoutable?
    
    // MARK: - Initializer
    
    init() {}
    
    // MARK: - Helpers

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        if let appRouteData = appRouteData(forURL: url) {
            handle(routeData: appRouteData)
            return true
        } else {
            return false
        }
    }

    func application(continue userActivity: NSUserActivity, with restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

//        let activityType = userActivity.activityType
//
//        if activityType == NSUserActivityTypeBrowsingWeb, let url = userActivity.webpageURL, let appRouteData = appRouteData(forURL: url) {
//            handle(routeData: appRouteData)
//            return true
//
//        } else if let bundleIdentifier = Bundle.main.bundleIdentifier, activityType.hasPrefix(bundleIdentifier) {
//
//            let query: [String: String] = {
//                guard let userInfo = userActivity.userInfo else { return [:] }
//                var dict = [String: String]()
//                userInfo.keys.forEach() { key in
//                    guard let key = key as? String, let value = userInfo[key] as? String else { return }
//                    dict[key.lowercased()] = value.lowercased()
//                }
//                return dict
//            }()
//            let pathComponents = activityType.removingPrefix(bundleIdentifier).components(separatedBy: ".")
//
//            if let appPath = appPath(forPathComponents: pathComponents, query: query) {
//                handle(routeData: AppRouteData(path: appPath, isAuthenticated: authorizationController.authorized))
//                return true
//            }
//        }
        return false
    }
    
    func handle(_ item: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        if let appPath = appPath(for: item) {
            handle(routeData: RouteData(path: appPath))
            completionHandler(true)
        }
    }
    
    // MARK: - AppPath handlers
    
    fileprivate func appPath(for item: UIApplicationShortcutItem) -> AppPath? {
        return nil
    }
    
    fileprivate func appRouteData(forURL url: URL) -> RouteData? {
        return nil
    }
    
    fileprivate func appRouteData(forPathComponents pathComponents: [String], query: [String: String] = [:]) -> RouteData? {
        guard let path = appPath(forPathComponents: pathComponents, query: query) else {
            return nil
        }
        return RouteData(path: path, parameters: query)
    }
    
    fileprivate func appPath(forPathComponents pathComponents: [String], query: [String: String] = [:]) -> AppPath? {
        let components = pathComponents.filter({ $0 != "/" && $0 != "" && $0 != "." }).map({ $0.lowercased() })
        return AppPath(pathComponents: components, query: query)
    }

    fileprivate func handle(routeData: RouteData) {
        router?.route(to: routeData, animated: true, completion: nil)
    }
}

// MARK: -

extension DeepLinkHandler: URLHandleable {
    
    // MARK: - URLHandleable
    
    func canHandle(_ url: URL) -> Bool {
        return appRouteData(forURL: url) != nil
    }
    
    func handle(_ url: URL) {
        guard let appRouteData = appRouteData(forURL: url) else { return }
        handle(routeData: appRouteData)
    }
}
