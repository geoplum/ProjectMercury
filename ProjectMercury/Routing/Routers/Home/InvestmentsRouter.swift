//
//  InvestmentsRouter.swift
//  ProjectMercury
//
//  Created by George Quentin on 07/01/2021.
//

import Foundation
import UIKit

// 2) - Each router class is a RoutingNode, which has a structure that implements it own dedicated setup and reset functions by looping throught the router parent and childrens. Each RoutingNode also requires a Presenter for presenting/pushing any required screen from this router.
final class InvestmentsRouter: NSObject {
    
    // MARK: - Properties
    
    let presenter: NavigationPresenter

    // MARK: - NavigationRoutable properties
    
    weak var parent: Router?
    let children: [Router] = []

    // MARK: - Initializer
    
    init(presenter: NavigationPresenter, parent: NavigationRoutable) {
        self.presenter = presenter
        self.parent = parent
        super.init()
    }
    
}

// MARK: -

extension InvestmentsRouter: NavigationRoutable {
    
    // MARK: - NavigationRoutable
    
    func canRoute(to routeData: RouteData) -> Bool {
        switch routeData.path {
        case .investments, .inviteFriends: return true
        default: return false
        }
    }
    
    func resetNavigation(for routeData: RouteData, animated: Bool, completion: (() -> Void)?) {
        switch routeData.path {
        case .investments(let name):
            // reset to invesments
            if let viewController = presenter.masterViewControllers.first(where: { $0 is InvestmentsViewController }) {
                presenter.popTo(viewController, animated: animated, completion: completion)
            } else {
                let viewController = InvestmentsViewController(title: name, router: self)
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
