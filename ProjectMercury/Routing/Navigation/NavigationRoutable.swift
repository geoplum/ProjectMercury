//
//  NavigationRoutable.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 02/01/2021.
//

import Foundation

// 2-) - NavigationRoutable: This is an extension of the router which holds the Presenter object that is used to present and push  UIViewControllers.
protocol NavigationRoutable: Router {
    
    var storeModel: GlobalStore.StoreModel? { get }
    var presenter: NavigationPresenter { get }
}

// MARK: - NavigationRoutable

extension NavigationRoutable {
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        presenter.dismissPresentedViewController(animated: animated, completion: completion)
    }
    
    func dismissAndRoute(to appPath: RouteData, animated: Bool = true, completion: (() -> Void)? = nil) {
        dismiss(animated: animated, completion: { [weak self] () in
            self?.route(to: appPath, animated: true, completion: completion)
        })
    }
    
}
