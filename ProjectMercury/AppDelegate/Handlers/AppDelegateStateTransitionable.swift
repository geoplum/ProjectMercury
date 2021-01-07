//
//  AppDelegateStateTransitionable.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 12/12/2020.
//

import UIKit

protocol AppDelegateStateTransitionable {
    
    func didBecomeActive(_ application: UIApplication)
    func willEnterForeground(_ application: UIApplication)
    func didEnterBackground(_ application: UIApplication)
}

extension AppDelegateStateTransitionable {
    
    func didBecomeActive(_ application: UIApplication) {}
    func willEnterForeground(_ application: UIApplication) {}
    func didEnterBackground(_ application: UIApplication) {}
}
