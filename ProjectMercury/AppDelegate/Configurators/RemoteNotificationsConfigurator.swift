//
//  RemoteNotificationsConfigurator.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 13/12/2020.
//

import UIKit

final class RemoteNotificationsConfigurator: AppDelegateConfigurable {

    // MARK: - Properties
    
    let router: NavigationRoutable
    
    // MARK: - Initializer
    
    init(router: NavigationRoutable) {
        self.router = router
    }

    func configure(_ scene: UIScene, willConnectTo session: UISceneSession) {
        
    }
}

// MARK: -

extension RemoteNotificationsConfigurator: AppDelegateStateTransitionable {
    // MARK: - MSMAppDelegateStateTransitionable
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        
    }
    
    func didRegisterForRemoteNotifications(with deviceToken: Data) {
        
    }
    
    func didFailToRegisterForRemoteNotifications(with error: Error) {
        
    }
}
