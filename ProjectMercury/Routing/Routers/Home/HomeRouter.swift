//
//  HomeRouter.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 13/12/2020.
//

import ComposableArchitecture
import Combine
import Foundation
import UIKit


// 3-) - HomeRouter: Each class conforming to NavigationRoutable can be considered as a RouteNode, which implements its own dedicated setup and reset functions and contains a Presenter that delegates the navigation between the screens of a RouteNode.
final class HomeRouter: NSObject {
    
    // MARK: - Properties
    
    var storeModel: RouterStore.StoreModel?
    let presenter: NavigationPresenter
    
    // MARK: - NavigationRoutable properties
    
    weak var parent: Router?
    private(set) var children: [Router] = []

    // MARK: - Initializer
    
    init(presenter: NavigationPresenter, parent: Router, store: RouterStore) {
        self.presenter = presenter
        self.parent = parent
        super.init()
        self.storeModel = store.addStoreModel(with: self)
        self.children = [
            InvestmentsRouter(presenter: presenter, parent: self, store: store)
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
            if let viewController = presenter.firstController(ofType: HomeViewController.self) {
                presenter.popTo(viewController, animated: animated, completion: completion)
            } else {
                let viewModel = HomeViewModel(storeModel: self.storeModel)
                let viewController = HomeViewController(viewModel: viewModel)
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
        case .pockets:
            let viewController = PocketsViewController(storeModel: self.storeModel)
            presenter.presentModal(NavigationController(rootViewController: viewController), animated: animated, completion: completion)
        
        default:
            completion?()
        }
    }
}
