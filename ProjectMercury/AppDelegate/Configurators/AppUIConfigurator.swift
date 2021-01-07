//
//  AppUIConfigurator.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 12/12/2020.
//

import UIKit

final class AppUIConfigurator: AppDelegateConfigurable {
    
    func configure(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
        // MARK: - Navigation Bar (default)
        UINavigationBar.appearance(whenContainedInInstancesOf: [NavigationController.self]).isTranslucent = false
        UINavigationBar.appearance(whenContainedInInstancesOf: [NavigationController.self]).barTintColor = UIColor(named: "primary")
        UINavigationBar.appearance(whenContainedInInstancesOf: [NavigationController.self]).tintColor = .white
        UINavigationBar.appearance(whenContainedInInstancesOf: [NavigationController.self]).titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
}
