//
//  Coordinator.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 12/12/2020.
//

import Foundation

protocol Coordinator: class {
    
    // MARK: -
    
    var parent: Coordinator? { get set }
    var children: [Coordinator] { get }
    
    // MARK: -
    
    func canRoute(to url: URL) -> Bool
    func route(to url: URL)
    func canRoute(to routeData: RouteData) -> Bool
    func route(to routeData: RouteData, animated: Bool, completion: (() -> Void)?)
    func resetNavigation(for routeData: RouteData, animated: Bool, completion: (() -> Void)?)
    func setupNavigation(for routeData: RouteData, animated: Bool, completion: (() -> Void)?)
}

// MARK: -

extension Coordinator {
    
    // MARK: - Helper functions
    
    fileprivate func childThatRoutes(to appPath: RouteData, ignore currentChild: Coordinator? = nil) -> Coordinator? {
        return children.first(where: { (child) -> Bool in
            guard currentChild !== child else { return false }
            if child.canRoute(to: appPath) {
                return true
            } else {
                return child.childThatRoutes(to: appPath) != nil
            }
        })
    }
    
    func route(to appPath: RouteData, from router: Coordinator?, animated: Bool, completion: (() -> Void)?) {
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
}
