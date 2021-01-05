//
//  RootRouter.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 12/12/2020.
//

import UIKit
import SwiftUI
import Combine

final class RootRouter: NSObject {
    
    // MARK: -

    enum TabItem: Int, CaseIterable {
        
        case home = 0
        case lostmoney = 1
        case cashback = 2
    }
    
    // MARK: -
    
    private struct TabRouting {
        
        let viewController: UIViewController
        let router: NavigationRoutable
    }

    // MARK: - Properties
    
    fileprivate let urlHandler: URLHandleable
    fileprivate let tabSelected = PassthroughSubject<TabItem, Never>()
    fileprivate var cancellable = Set<AnyCancellable>()
    
    // MARK: - MSMNavigationRoutable property
    
    private(set) var children: [Coordinator]
    
    // MARK: - Lazy properties
    
    fileprivate lazy var tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.alpha = 0
        tabBarController.delegate = self
        return tabBarController
    }()
    
    // MARK: - Initializer
    
    init(with urlHandler: URLHandleable) {
        self.urlHandler = urlHandler
        self.children = []
        super.init()
    }
    
    // MARK: - Private setup functions
    
    fileprivate func setup() {
        buildTabBarController()
        setupBindings()
    }
    
    private func makeTabRoutings(from tabItems: [TabItem]) -> [TabRouting] {
        
        return tabItems.compactMap { (tabBarItem) -> TabRouting? in
            switch tabBarItem {
            case .home:
                let presenter = NavigationPresenter()
                let router = HomeRouter(presenter: presenter, parent: self)
                router.route(to: RouteData(path: .home), animated: false, completion: nil)
                return TabRouting(viewController: presenter, router: router)
            case .lostmoney:
                let presenter = NavigationPresenter()
                let router = LostMoneyRouter(presenter: presenter, parent: self)
                router.route(to: RouteData(path: .lostMoney), animated: false, completion: nil)
                return TabRouting(viewController: presenter, router: router)

            case .cashback:
                let presenter = NavigationPresenter()
                let router = CashBackRouter(presenter: presenter, parent: self)
                router.route(to: RouteData(path: .cashback), animated: false, completion: nil)
                return TabRouting(viewController: presenter, router: router)

            }
        }
    }
    
    private func buildTabBarController() {
        let tabRoutings = makeTabRoutings(from: TabItem.allCases)
        children = tabRoutings.map { $0.router }
        let viewControllers = tabRoutings.map { $0.viewController }
        tabBarController.tabBar.alpha = 1
        tabBarController.view.backgroundColor = .clear
        tabBarController.viewControllers = viewControllers
        viewControllers
            .compactMap { $0 as? TabBarEmbeddable }
            .forEach { $0.didEmbedIn(tabBar: tabBarController.tabBar) }
        
    }

    // MARK: - Public functions

    private func selectTabItem(_ item: TabItem) {
        tabBarController.selectedIndex = item.rawValue
    }
    
    // MARK: - Private functions
    
    fileprivate func setupBindings() {
        tabSelected
            .scan([TabItem.allCases[0]]) { (sum, new) -> [TabItem] in
                return Array((sum + [new]).suffix(2))
            }.filter { (pair) -> Bool in
                guard pair.count == 2 else { return false }
                return pair[0] == pair[1]
            }.map { (pair) -> TabItem in
                return pair[0]
            }
            .sink(receiveValue: { (result) in
                self.popNavigationToRootIfNeeded()
            })
            .store(in: &cancellable)
    }
    
    // MARK: - Routing helpers
    
    func popNavigationToRootIfNeeded() {
        if let tabItemController = tabBarController.selectedViewController as? NavigationPresenter {
            tabItemController.popToRoot(animated: true, completion: nil)
        }
    }
    
    fileprivate func startRouting() {
        setup()
        route(to: RouteData(path: .home), animated: true, completion: nil)
    }
    
}

// MARK: -

extension RootRouter: UITabBarControllerDelegate {
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let tabItem = TabItem(rawValue: tabBarController.selectedIndex) else { return }
        tabSelected.send(tabItem)
    }
}


// MARK: -

extension RootRouter: AppDelegateConfigurable {
    
    // MARK: - MSMAppDelegateConfigurable
    
    func configure(_ scene: UIScene, willConnectTo session: UISceneSession) {
        guard let delegate = scene.delegate as? SceneDelegate, let windowScene = (scene as? UIWindowScene) else { return }

        delegate.window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        delegate.window?.windowScene = windowScene
        delegate.window?.backgroundColor = .white
        delegate.window?.rootViewController = tabBarController
        delegate.window?.makeKeyAndVisible()
        
        startRouting()
    }
}

// MARK: -

extension RootRouter: NavigationRoutable {
    
    // MARK: - MSMNavigationRoutable
    
    var presenter: NavigationPresenter {
        return NavigationPresenter()
    }

    var parent: Coordinator? {
        get { return nil }
        set { }
    }
    
    fileprivate func resolveUnknownAppPath(with component: String, onResolution: @escaping (AppPath?) -> Void) {
       // resolve any unkown paths or deep links here
    }
    
    func resetNavigation(for routeData: RouteData, animated: Bool, completion: (() -> Void)?) {
        children.forEach({ $0.resetNavigation(for: routeData, animated: animated, completion: nil) })
        let index = children.firstIndex { $0.canSubtreeRoute(to: routeData)  }
        if let i = index, let tab = TabItem(rawValue: i) {
            selectTabItem(tab)
        } else {
            selectTabItem(.home)
        }
        completion?()
    }
    
    func setupNavigation(for routeData: RouteData, animated: Bool, completion: (() -> Void)?) {
        switch routeData.path {
        case .unknown(let component):
            resolveUnknownAppPath(with: component) { [weak self] (resolvedAppPath) in
                guard let self = self else { return }
                if let resolvedAppPath = resolvedAppPath {
                    self.setupTabBarNavigation(for: RouteData(path: resolvedAppPath), animated: animated, completion: completion)
                }
                completion?()
            }
        default:
            setupTabBarNavigation(for: routeData, animated: animated, completion: completion)
        }
    }
    
    fileprivate func setupTabBarNavigation(for routeData: RouteData, animated: Bool, completion: (() -> Void)?) {
        // show screens presented by tabBar here
        switch routeData.path {
        case .alert(let alertController):
            tabBarController.present(alertController, animated: true, completion: completion)
            
        default:
            let index = children.firstIndex { $0.canSubtreeRoute(to: routeData)  }
            if let i = index {
                children[i].route(to: routeData, animated: animated, completion: completion)
            } else {
                completion?()
            }
        }
    }
    
    func canRoute(to routeData: RouteData) -> Bool {
        switch routeData.path {
        case .alert, .unknown: return true
        default: return false
        }
    }
    
    func canRoute(to url: URL) -> Bool {
        return urlHandler.canHandle(url)
    }
    
    func route(to url: URL) {
        guard canRoute(to: url) else { return }
        urlHandler.handle(url)
    }
}
