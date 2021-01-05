//
//  NavigationRoutable.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 02/01/2021.
//

import Foundation

protocol NavigationRoutable: Coordinator {
    
    var presenter: NavigationPresenter { get }

}

// MARK: - NavigationRoutable

extension NavigationRoutable {
    
    func dismissPresentedViewController(animated: Bool = true, completion: (() -> Void)? = nil) {
        presenter.dismissPresentedViewController(animated: animated, completion: completion)
    }
    
    func dismissPresentedViewControllerAndRoute(to appPath: RouteData, animated: Bool = true, completion: (() -> Void)? = nil) {
        dismissPresentedViewController(animated: animated, completion: { [weak self] () in
            self?.route(to: appPath, animated: true, completion: completion)
        })
    }
    
    func dismissFromMasterViewControllerAndRoute(to appPath: RouteData, animated: Bool = true, completion: (() -> Void)? = nil) {
        presenter.dismissFromMasterViewController { [weak self] in
            self?.route(to: appPath, animated: true, completion: completion)
        }
    }
}
