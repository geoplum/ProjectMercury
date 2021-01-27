//
//  TabBarRouter.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 12/12/2020.
//

import UIKit
import SwiftUI
import Combine

final class TabBarRouter: NSObject {
    
    // MARK: -

    enum TabItem: Int, CaseIterable {
        
        case home = 0
        case lostmoney = 1
        case cashback = 2
    }
    
    // MARK: -
    
    private struct TabRouting {
        
        let item: TabItem
        let router: NavigationRoutable
    }

    // MARK: - Properties
    
    fileprivate let tabSelected = PassthroughSubject<TabItem, Never>()
    fileprivate var cancellable = Set<AnyCancellable>()
    
    // MARK: - NavigationRoutable property
    
    private(set) var children: [Router]
    var parent: Router?
    
    // MARK: - Lazy properties
    
    fileprivate lazy var tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.alpha = 0
        tabBarController.delegate = self
        return tabBarController
    }()
    
    // MARK: - Initializer
    
    override init() {
        self.children = []
        super.init()
    }
    
    // MARK: - Private setup functions
    
    private func makeTabRoutings(from tabItems: [TabItem]) -> [TabRouting] {
        
        return tabItems.compactMap { (tabBarItem) -> TabRouting? in
            switch tabBarItem {
            case .home:
                let router = HomeRouter(presenter: NavigationPresenter(), parent: self)
                router.route(to: RouteData(path: .home), animated: false, completion: nil)
                return TabRouting(item: tabBarItem, router: router)
            case .lostmoney:
                let router = LostMoneyRouter(presenter: NavigationPresenter(), parent: self)
                router.route(to: RouteData(path: .lostMoney), animated: false, completion: nil)
                return TabRouting(item: tabBarItem, router: router)

            case .cashback:
                let router = CashBackRouter(presenter: NavigationPresenter(), parent: self)
                router.route(to: RouteData(path: .cashback), animated: false, completion: nil)
                return TabRouting(item: tabBarItem, router: router)
            }
        }
    }
    
    private func buildTabBarController() {
        let tabRoutings = makeTabRoutings(from: TabItem.allCases)
        children = tabRoutings.map { $0.router }
        let viewControllers: [UIViewController] = tabRoutings.compactMap { $0.router.presenter }
        
        tabBarController.tabBar.alpha = 1
        tabBarController.view.backgroundColor = .clear
        tabBarController.viewControllers = viewControllers
        viewControllers
            .compactMap { $0 as? TabBarEmbeddable }
            .forEach { $0.didEmbedIn(tabBar: tabBarController.tabBar) }
        
        handle(routeData: RouteData(path: .home))
    }

    // MARK: - Public functions

    private func selectTabItem(_ item: TabItem) {
        tabBarController.selectedIndex = item.rawValue
    }
    
    // MARK: - Private functions
    
    fileprivate func registerObservers() {
        
        // reset pop view controllers on current tab
//        tabSelected
//            .scan([TabItem.allCases[0]]) { (sum, new) -> [TabItem] in
//                return Array((sum + [new]).suffix(2))
//            }.filter { (pair) -> Bool in
//                guard pair.count == 2 else { return false }
//                return pair[0] == pair[1]
//            }
//            .sink(receiveValue: { _ in
//                self.popNavigationToRootIfNeeded()
//            })
//            .store(in: &cancellable)
    }
    
    // MARK: - Routing helpers
    
    func popNavigationToRootIfNeeded() {
        if let tabItemController = tabBarController.selectedViewController as? NavigationPresenter {
            tabItemController.popToRoot(animated: true, completion: nil)
        }
    }
    
    fileprivate func startRouting() {
        buildTabBarController()
        registerObservers()
    }
    
}

// MARK: -

extension TabBarRouter: UITabBarControllerDelegate {
    
    // MARK: - UITabBarControllerDelegate
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let tabItem = TabItem(rawValue: tabBarController.selectedIndex) else { return }
        tabSelected.send(tabItem)
    }
}


// MARK: -

extension TabBarRouter: AppDelegateConfigurable {
    
    // MARK: - AppDelegateConfigurable
    
    func configure(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        guard let delegate = application.delegate as? AppDelegate else { return }
        let mainWindow = UIWindow(frame: UIScreen.main.bounds)
        mainWindow.backgroundColor = .white
        mainWindow.rootViewController = tabBarController
        delegate.window = mainWindow
        delegate.window?.makeKeyAndVisible()
        
        // Tell router to take over
        self.startRouting()
    }
}

// MARK: -

extension TabBarRouter: Router {

    // MARK: - NavigationRoutable
    
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
        return canHandle(url)
    }
    
    func route(to url: URL) {
        guard canRoute(to: url) else { return }
        handle(url)
    }

}

// MARK: -

extension TabBarRouter: URLHandleable {
    
    // MARK: - AppPath handlers
    
    func appPath(for item: UIApplicationShortcutItem) -> AppPath? {
        return nil
    }
    
    func appRouteData(forURL url: URL) -> RouteData? {
        return nil
    }
    
    fileprivate func appRouteData(forPathComponents pathComponents: [String], query: [String: String] = [:]) -> RouteData? {
        guard let path = appPath(forPathComponents: pathComponents, query: query) else {
            return nil
        }
        return RouteData(path: path, parameters: query)
    }
    
    fileprivate func appPath(forPathComponents pathComponents: [String], query: [String: String] = [:]) -> AppPath? {
        let components = pathComponents.filter({ $0 != "/" && $0 != "" && $0 != "." }).map({ $0.lowercased() })
        return AppPath(pathComponents: components, query: query)
    }

    func handle(routeData: RouteData) {
        route(to: routeData, animated: true, completion: nil)
    }

    // MARK: - URLHandleable
    
    func canHandle(_ url: URL) -> Bool {
        return appRouteData(forURL: url) != nil
    }
    
    func handle(_ url: URL) {
        guard let appRouteData = appRouteData(forURL: url) else { return }
        handle(routeData: appRouteData)
    }
}
