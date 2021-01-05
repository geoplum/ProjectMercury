//
//  NavigationPresenter.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 13/12/2020.
//

import UIKit
import Combine

final class NavigationPresenter: UIViewController {
    
    private typealias ViewControllerPresentation = (UIViewController, animated: Bool, completion: (() -> Void)?)

    // MARK: - Properties
    
    fileprivate(set) lazy var masterNavigationController: NavigationController = NavigationController()
    override var preferredStatusBarStyle: UIStatusBarStyle { return .lightContent }
    let dismissedViewController = PassthroughSubject<UIViewController?, Never>()
    let presentationViewController = PassthroughSubject<UIViewController?, Never>()
    var masterViewControllers: [UIViewController] { return masterNavigationController.viewControllers }

    // MARK: - Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    // MARK: - UIViewController life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    
    // MARK: - Setup
    
    private func setupUI() {

        edgesForExtendedLayout = []
        addChild(masterNavigationController)
        view.addSubview(masterNavigationController.view)
        masterNavigationController.view.frame = self.view.bounds
        masterNavigationController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        masterNavigationController.view.translatesAutoresizingMaskIntoConstraints = true
        masterNavigationController.didMove(toParent: self)
    }
    
    private func setupBindings() {
        
    }
    
    // MARK: - Pop controller
    
    func popLast(animated: Bool = true, completion: (() -> Void)?) {
        masterNavigationController.popViewController(animated: animated, completion: completion)
    }
    
    func popTo(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)?) {
        masterNavigationController.popToViewController(viewController, animated: animated, completion: completion)
    }
    
    func popToRoot(animated: Bool = true, completion: (() -> Void)?) {
        if let rootViewController = masterViewControllers.first {
            popTo(rootViewController, animated: animated, completion: completion)
        } else {
            completion?()
        }
    }
    
    func popInPresentedNavigationController(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)?) {
        let navigationController = masterNavigationController.presentedViewController as? NavigationController ?? masterNavigationController
        navigationController.popToViewController(viewController, animated: animated, completion: completion)
    }
    
    // MARK: - Push controller
    
    private func pushInDetailContainer(_ presentation: ViewControllerPresentation) {
        let viewController = presentation.0
        let animated = presentation.animated
        let completion = presentation.completion
        masterNavigationController.pushViewController(viewController, animated: animated, completion: completion)
    }
    
    func push(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)?) {
        masterNavigationController.pushViewController(viewController, animated: animated, completion: completion)
    }
    
    func pushInPresentedNavigationController(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)?) {
        let navigationController = masterNavigationController.presentedViewController as? NavigationController ?? masterNavigationController
        navigationController.pushViewController(viewController, animated: animated, completion: completion)
    }
    
    // MARK: - Present controller
    
    func presentModal(_ viewController: UIViewController, animated: Bool = true, completion: (() -> Void)?) {
        let navigationController = masterNavigationController.presentedViewController as? NavigationController ?? masterNavigationController
        present(viewController, in: navigationController, animated: animated, completion: completion)
    }
    
    private func present(_ viewController: UIViewController, in presentationController: UIViewController, animated: Bool = true, completion: (() -> Void)?) {
        dismissedViewController.send(nil)
        presentationViewController.send(presentationController)
        presentationController.present(viewController, animated: animated, completion: completion)
    }
    
    // MARK: - Dismissable
    
    func dismissAndPopViewController(animated: Bool = false, completion: (() -> Void)?) {
        dismissPresentedViewController { [weak self] () in
            self?.popLast(animated: animated, completion: completion)
        }
    }
    
    func dismissPresentedViewController(animated: Bool = true, completion: (() -> Void)?) {
        let presentedController = masterNavigationController.presentedViewController ?? masterNavigationController
        if let presentationController = (presentedController as? NavigationController)?.topViewController {
            dismiss(presentationController, animated: animated, completion: completion)
        } else if let presentationController = (presentedController as? NavigationController) {
            dismiss(presentationController, animated: animated, completion: completion)
        } else if let presentationController = masterNavigationController.topViewController {
            dismiss(presentationController, animated: animated, completion: completion)
        } else {
            dismiss(masterNavigationController, animated: animated, completion: completion)
        }
    }
    
    func dismissFromMasterViewController(animated: Bool = true, completion: (() -> Void)?) {
        if let presentationController = masterNavigationController.topViewController {
            dismiss(presentationController, animated: animated, completion: completion)
        } else {
            dismiss(masterNavigationController, animated: animated, completion: completion)
        }
    }
    
    private func dismiss(_ presentationController: UIViewController, animated: Bool = true, completion: (() -> Void)?) {
        presentationController.dismiss(animated: animated, completion: { [weak self] () in
            self?.dismissedViewController.send(presentationController)
            self?.presentationViewController.send(nil)
            completion?()
        })
    }
    
}

// MARK: -

extension NavigationPresenter: TabBarEmbeddable {
    
    // MARK: - UITabBarEmbeddable

    func didEmbedIn(tabBar: UITabBar) {
        title = masterNavigationController.viewControllers.first?.title
        tabBarItem.image = masterNavigationController.viewControllers.first?.tabBarItem.image
        tabBarItem.selectedImage = masterNavigationController.viewControllers.first?.tabBarItem.selectedImage
    }
}
