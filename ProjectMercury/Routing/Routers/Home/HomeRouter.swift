//
//  HomeRouter.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 13/12/2020.
//

import Foundation
import UIKit

protocol HomeDataPassing
{
    var dataStore: DataStore? { get }
}

// 3) HomeRouter: Each class conforming to NavigationRoutable can be considered as a RouteNode, which implements its own dedicated setup and reset functions and contains a Presenter that delegates the navigation between the screens of a RouteNode.
final class HomeRouter: NSObject, HomeDataPassing {
    
    // MARK: - Properties
    
    let presenter: NavigationPresenter
    var dataStore: DataStore?

    // MARK: - NavigationRoutable properties
    
    weak var parent: Router?
    private(set) var children: [Router] = []

    // MARK: - Initializer
    
    init(presenter: NavigationPresenter, parent: Router) {
        self.presenter = presenter
        self.parent = parent
        super.init()
        self.children = [
            InvestmentsRouter(presenter: presenter, parent: self)
        ]
    }
    
}

// MARK: -

extension HomeRouter: NavigationRoutable {
    
    // MARK: - NavigationRoutable
    
    func canRoute(to routeData: RouteData) -> Bool {
        switch routeData.path {
        case .home, .pockets, .inviteFriends: return true
        default: return false
        }
    }
    
    func resetNavigation(for routeData: RouteData, animated: Bool, completion: (() -> Void)?) {
        switch routeData.path {
        case .home:
            // reset to home
            if let viewController = presenter.masterViewControllers.first(where: { $0 is HomeViewController }) {
                presenter.popTo(viewController, animated: animated, completion: completion)
            } else {
                let viewController = HomeViewController(router: self)
                presenter.push(viewController, animated: animated, completion: completion)
            }
        case .pockets:
            // reset to pockets
            if let viewController = presenter.masterViewControllers.first(where: { $0 is PocketsViewController }) {
                presenter.popTo(viewController, animated: animated, completion: completion)
            } else {
                let viewController = PocketsViewController(router: self)
                presenter.push(viewController, animated: animated, completion: completion)
            }
        
        default:
            completion?()
        }
    }
    
    func setupNavigation(for routeData: RouteData, animated: Bool, completion: (() -> Void)?) {
        switch routeData.path {

        case .inviteFriends:
            let viewController = InviteFriendsViewController(router: self)
            presenter.presentModal(NavigationController(rootViewController: viewController), animated: true, completion: completion)
        default:
            completion?()
        }
    }
}
