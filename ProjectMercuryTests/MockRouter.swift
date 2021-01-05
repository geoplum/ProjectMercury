//
//  MockRouter.swift
//  ProjectMercuryTests
//
//  Created by GEORGE QUENTIN on 02/01/2021.
//

import XCTest
@testable import ProjectMercury

final class MockRouter: NavigationRoutable {

    let presenter: NavigationPresenter
    
    // MARK: -
    
    weak var parent: Coordinator?
    let children: [Coordinator] = []
    
    // MARK: -
    
    init() {
        presenter = NavigationPresenter()
    }
    
    // MARK: -
    
    func canRoute(to routeData: RouteData) -> Bool { return true }
    func route(to routeData: RouteData, animated: Bool, completion: (() -> Void)?) {}
    func resetNavigation(for routeData: RouteData, animated: Bool, completion: (() -> Void)?) {}
    func setupNavigation(for routeData: RouteData, animated: Bool, completion: (() -> Void)?) {}
    
}
