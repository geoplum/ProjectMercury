//
//  InvestmentsRouter.swift
//  ProjectMercury
//
//  Created by George Quentin on 07/01/2021.
//

import Foundation
import UIKit

// 3-) - InvestmentRouter: Each class conforming to NavigationRoutable can be considered as a RouteNode, which implements its own dedicated setup and reset functions and contains a Presenter that delegates the navigation between the screens of a RouteNode.
final class InvestmentsRouter: NSObject {
    
    // MARK: - Properties
    
    let presenter: NavigationPresenter
    let storeModel: GlobalStore.StoreModel

    // MARK: - NavigationRoutable properties
    
    weak var parent: Router?
    let children: [Router] = []

    // MARK: - Initializer
    
    init(presenter: NavigationPresenter, parent: NavigationRoutable, store: GlobalStore.StoreModel) {
        self.presenter = presenter
        self.parent = parent
        self.storeModel = store
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
                let viewController = InvestmentsViewController(title: name, storeModel: self.storeModel)
                presenter.push(viewController, animated: animated, completion: completion)
            }
            
        default:
            completion?()
        }
    }
    
    func setupNavigation(for routeData: RouteData, animated: Bool, completion: (() -> Void)?) {
        switch routeData.path {
        case .inviteFriends:
            let viewController = InviteFriendsViewController(storeModel: self.storeModel)
            presenter.presentModal(NavigationController(rootViewController: viewController), animated: true, completion: completion)
        default:
            completion?()
        }
    }
}
