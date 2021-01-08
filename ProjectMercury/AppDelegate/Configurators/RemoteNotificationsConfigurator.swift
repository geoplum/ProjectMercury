//
//  RemoteNotificationsConfigurator.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 13/12/2020.
//

import UIKit

final class RemoteNotificationsConfigurator: AppDelegateConfigurable {

    // MARK: - Properties
    
    let router: Router
    
    // MARK: - Initializer
    
    init(router: Router) {
        self.router = router
    }

    func configure(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
    }
}

// MARK: -

extension RemoteNotificationsConfigurator: AppDelegateStateTransitionable {
    
    // MARK: - AppDelegateStateTransitionable
    
    func didBecomeActive(_ application: UIApplication) {
        
    }
    
    func didRegisterForRemoteNotifications(with deviceToken: Data) {
        
    }
    
    func didFailToRegisterForRemoteNotifications(with error: Error) {
        
    }
}
