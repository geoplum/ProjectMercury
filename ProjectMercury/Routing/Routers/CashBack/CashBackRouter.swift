//
//  CashBackRouter.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 13/12/2020.
//

import Foundation
import UIKit

// 3-) - CashBackRouter: Each class conforming to NavigationRoutable can be considered as a RouteNode, which implements its own dedicated setup and reset functions and contains a Presenter that delegates the navigation between the screens of a RouteNode.

final class CashBackRouter: NSObject {
    
    // MARK: - Properties
    
    lazy var storeModel = GlobalStore.StoreModel(GlobalStore.Value(initialState: store.state, reducer: store.reducer, environment: GlobalStore.Environment(router: self)))
    let store: GlobalStore
    let presenter: NavigationPresenter
    
    // MARK: - NavigationRoutable properties
    
    weak var parent: Router?
    let children: [Router] = []

    // MARK: - Initializer
    
    init(presenter: NavigationPresenter, parent: Router, store: GlobalStore) {
        self.presenter = presenter
        self.parent = parent
        self.store = store
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
                let viewController = CashBackViewController(storeModel: self.storeModel)
                presenter.push(viewController, animated: animated, completion: completion)
            }
            
        default:
            completion?()
        }
    }
    
    func setupNavigation(for routeData: RouteData, animated: Bool, completion: (() -> Void)?) {
        switch routeData.path {
        case .cashbackDetail:
            let viewController = CashbackDetailViewController(storeModel: self.storeModel)
            presenter.push(viewController, animated: animated, completion: completion)
            
        case .inviteFriends:
            let viewController = InviteFriendsViewController(storeModel: self.storeModel)
            presenter.presentModal(NavigationController(rootViewController: viewController), animated: true, completion: completion)
        default:
            completion?()
        }
    }
}
