//
//  AppDelegateStateTransitionable.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 12/12/2020.
//

import UIKit

protocol AppDelegateStateTransitionable {
    
    func sceneDidBecomeActive(_ scene: UIScene)
    func sceneWillEnterForeground(_ scene: UIScene)
    func sceneDidEnterBackground(_ scene: UIScene)
}

extension AppDelegateStateTransitionable {
    
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}
