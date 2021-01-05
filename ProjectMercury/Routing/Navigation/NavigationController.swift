//
//  NavigationController.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 13/12/2020.
//

import UIKit

public final class NavigationController: UINavigationController {

    public override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
}

// MARK: -

extension NavigationController: TabBarEmbeddable {
    
    // MARK: -
    
    public func didEmbedIn(tabBar: UITabBar) {
        viewControllers
            .compactMap { $0 as? TabBarEmbeddable }
            .forEach { $0.didEmbedIn(tabBar: tabBar) }
    }
}

// MARK: - UINavigationController Completion

extension UINavigationController {
    
    public func pushViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        pushViewController(viewController, animated: animated)
        if let transitionCoordinator = transitionCoordinator, animated {
            transitionCoordinator.animate(alongsideTransition: { context in
                viewController.setNeedsStatusBarAppearanceUpdate()
            }, completion: { context in
                completion?()
            })
        } else { completion?() }
    }
    
    @discardableResult public func popViewController(animated: Bool, completion: (() -> Void)? = nil) -> UIViewController? {
        let viewController = popViewController(animated: animated)
        if let transitionCoordinator = transitionCoordinator, animated {
            transitionCoordinator.animate(alongsideTransition: { _ in }, completion: { context in
                completion?()
            })
        } else { completion?() }
        return viewController
    }
    
    @discardableResult public func popToViewController(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) -> [UIViewController]? {
        let viewControllers = popToViewController(viewController, animated: animated)
        if let transitionCoordinator = transitionCoordinator, animated {
            transitionCoordinator.animate(alongsideTransition: { _ in }, completion: { context in
                completion?()
            })
        } else { completion?() }
        return viewControllers
    }
    
    @discardableResult public func popToRootViewController(animated: Bool, completion: (() -> Void)? = nil) -> [UIViewController]? {
        let viewControllers = popToRootViewController(animated: animated)
        if let transitionCoordinator = transitionCoordinator, animated {
            transitionCoordinator.animate(alongsideTransition: { _ in }, completion: { context in
                completion?()
            })
        } else { completion?() }
        return viewControllers
    }
}
