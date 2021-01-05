//
//  CashBackRouter.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 13/12/2020.
//

import Foundation
import UIKit

final class CashBackRouter: NSObject {
    
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

extension CashBackRouter: NavigationRoutable {
    
    // MARK: - NavigationRoutable
    
    func canRoute(to routeData: RouteData) -> Bool {
        switch routeData.path {
        case .cashback, .cashbackDetail, .inviteFriends: return true
        default: return false
        }
    }
    
    func resetNavigation(for routeData: RouteData, animated: Bool, completion: (() -> Void)?) {
        switch routeData.path {
        case .cashback:
            // reset to cashback
            if let viewController = presenter.masterViewControllers.first(where: { $0 is CashBackViewController }) {
                presenter.popTo(viewController, animated: animated, completion: completion)
            } else {
                let viewController = CashBackViewController(router: self)
                presenter.push(viewController, animated: animated, completion: completion)
            }
            
        default:
            completion?()
        }
    }
    
    func setupNavigation(for routeData: RouteData, animated: Bool, completion: (() -> Void)?) {
        switch routeData.path {
        case .cashbackDetail:
            let viewController = CashbackDetailViewController(router: self)
            presenter.push(viewController, animated: animated, completion: completion)
            
        case .inviteFriends:
            let viewController = InviteFriendsViewController(router: self)
            presenter.presentModal(NavigationController(rootViewController: viewController), animated: true, completion: completion)
        default:
            completion?()
        }
    }
}
