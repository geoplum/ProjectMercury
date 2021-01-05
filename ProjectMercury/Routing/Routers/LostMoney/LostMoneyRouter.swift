//
//  LostMoneyRouter.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 13/12/2020.
//

import Foundation
import UIKit

final class LostMoneyRouter: NSObject {
    
    // MARK: - Properties
    
    let presenter: NavigationPresenter

    // MARK: - MSMNavigationRoutable properties
    
    weak var parent: Coordinator?
    let children: [Coordinator] = []

    // MARK: - Initializer
    
    init(presenter: NavigationPresenter, parent: NavigationRoutable) {
        self.presenter = presenter
        self.parent = parent
        super.init()
    }

}

// MARK: -

extension LostMoneyRouter: NavigationRoutable {
    
    // MARK: - NavigationRoutable
    
    func canRoute(to routeData: RouteData) -> Bool {
        switch routeData.path {
        case .lostMoney, .lostMoneyDetail, .inviteFriends: return true
        default: return false
        }
    }
    
    func resetNavigation(for routeData: RouteData, animated: Bool, completion: (() -> Void)?) {
        switch routeData.path {
        case .lostMoney:
            // reset to lost money
            if let viewController = presenter.masterViewControllers.first(where: { $0 is LostMoneyViewController }) {
                presenter.popTo(viewController, animated: animated, completion: completion)
            } else {
                let viewController = LostMoneyViewController(router: self)
                presenter.push(viewController, animated: animated, completion: completion)
            }
        default:
            completion?()
        }
    }
    
    func setupNavigation(for routeData: RouteData, animated: Bool, completion: (() -> Void)?) {
        switch routeData.path {
        case .lostMoneyDetail:
            let viewController = LostMoneyDetailViewController(router: self)
            presenter.push(viewController, animated: animated, completion: completion)
        case .inviteFriends:
            let viewController = InviteFriendsViewController(router: self)
            presenter.presentModal(NavigationController(rootViewController: viewController), animated: true, completion: completion)
            
        default:
            completion?()
        }
    }
}
