//
//  Router.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 12/12/2020.
//
// https://github.com/nikans/MonarchRouter
// https://www.raywenderlich.com/books/design-patterns-by-tutorials/v3.0/chapters/23-coordinator-pattern
// https://khanlou.com/2015/01/the-coordinator/
// https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps

import Foundation

// 1-) - Router: This is the app routing Coordinator where each route-node has a parent and potential children.
protocol Router: class {
    
    // MARK: - Coordinator
    
    var parent: Router? { get set }
    var children: [Router] { get }
    
    /// We check if we can route to a screen using a URL
    /// - parameter url: The URL of the destination screen
    /// - returns: Bool
    func canRoute(to url: URL) -> Bool
    
    /// Route to a screen using a URL
    /// - parameter url: The URL of the destination screen
    func route(to url: URL)
    
    /// If we cannot route to a given path, we check all the children of the current router to see if they can route to the given path
    /// - parameter appPath: The RouteData which contains the path and paramters of a screen
    /// - returns: Bool
    func canRoute(to routeData: RouteData) -> Bool
    
    /// A  function for routing using the current router as parent
    /// - parameter appPath: The RouteData which contains the path and paramters of a screen
    func route(to routeData: RouteData, animated: Bool, completion: (() -> Void)?)
    
    /// A  function for dismissing viewcontrollers in the current router
    func dismiss(animated: Bool, completion: (() -> Void)?)
    
    /// A  function for dismissing viewcontrollers in the current router and then go to a given destination from the current router
    /// - parameter appPath: The RouteData which contains the path and paramters of a screen
    func dismissAndRoute(to appPath: RouteData, animated: Bool, completion: (() -> Void)?)
    
    // MARK: - Navigation
    
    /// A  function to reset to the navigation of the router. This is always called before setupNavigation.
    /// - parameter appPath: The RouteData which contains the path and paramters of a screen
    func resetNavigation(for routeData: RouteData, animated: Bool, completion: (() -> Void)?)
    
    /// A  function to setup all the screen that will be pushed or presented within this router. This is always called after resetNavigation.
    /// - parameter appPath: The RouteData which contains the path and paramters of a screen
    func setupNavigation(for routeData: RouteData, animated: Bool, completion: (() -> Void)?)
}

// MARK: -

extension Router {
    
    // MARK: - Helper functions
    
    /// A private function for finding the router that has the path that we should route to
    /// - parameter appPath: The RouteData which contains the path and paramters of a screen
    /// - parameter currentChild: An optional router that can be used to ignore its children
    /// - returns: Router
    fileprivate func childThatRoutes(to appPath: RouteData, ignore currentChild: Router? = nil) -> Router? {
        return children.first(where: { (child) -> Bool in
            guard currentChild !== child else { return false }
            if child.canRoute(to: appPath) {
                return true
            } else {
                return child.childThatRoutes(to: appPath) != nil
            }
        })
    }
    
    /// A function that handles the routing between parent and childrens of the current router. It will either:
    /// 1 - let the current router handle the destination of the given path
    /// 2 - let the childen routers of the current router handle the destination of the given path
    /// 3 - let the parent handle the destination of the given path
    /// - parameter appPath: The RouteData which contains the path and paramters of a screen
    /// - parameter router: An optional router that can be used in the case were we cannot route from the current router
    fileprivate func route(to appPath: RouteData, from router: Router?, animated: Bool, completion: (() -> Void)?) {
        if canRoute(to: appPath) {
            resetNavigation(for: appPath, animated: animated, completion: {
                self.setupNavigation(for: appPath, animated: animated, completion: completion)
            })
        } else if let child = childThatRoutes(to: appPath, ignore: router) {
            resetNavigation(for: appPath, animated: animated, completion: {
                child.route(to: appPath, animated: animated, completion: completion)
            })
        } else {
            parent?.route(to: appPath, from: self, animated: animated, completion: completion)
        }
    }
    
    // MARK: - Coordinator
    
    func canSubtreeRoute(to appPath: RouteData) -> Bool {
        guard !canRoute(to: appPath) else { return true }
        return children.first(where: { $0.canSubtreeRoute(to: appPath) }) != nil
    }
    
    // MARK: - Default implementation
    
    func route(to appPath: RouteData, animated: Bool, completion: (() -> Void)?) {
        route(to: appPath, from: self, animated: animated, completion: completion)
    }
    
    func canRoute(to url: URL) -> Bool {
        guard let parent = parent else { return false }
        return parent.canRoute(to: url)
    }
    
    func route(to url: URL) {
        parent?.route(to: url)
    }
    
    func dismiss(animated: Bool, completion: (() -> Void)?) {}
    func dismissAndRoute(to appPath: RouteData, animated: Bool, completion: (() -> Void)?) {}
}
