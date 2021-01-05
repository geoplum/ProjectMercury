//
//  AppDelegateURLHandleable.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 13/12/2020.
//

import UIKit

protocol AppDelegateURLHandleable: class {

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool
    func application(continue userActivity: NSUserActivity, with restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
}

extension AppDelegateURLHandleable {
    
    func application(continue userActivity: NSUserActivity, with restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return false
    }
}
