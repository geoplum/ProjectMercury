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
    
    weak var router: TabBarRouter?
    
    // MARK: - Initializer
    
    init(router: TabBarRouter) {
        self.router = router
    }
    
    // MARK: - Helpers

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        if let appRouteData = router?.appRouteData(forURL: url) {
            router?.handle(routeData: appRouteData)
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
        if let appPath = router?.appPath(for: item) {
            router?.handle(routeData: RouteData(path: appPath))
            completionHandler(true)
        }
    }
    
}
