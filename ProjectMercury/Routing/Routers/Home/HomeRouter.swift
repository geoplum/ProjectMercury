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

typealias Store = ComposableArchitecture.Store<State, Action>

struct State {
    let router: NavigationRoutable
}

enum Action {
    case dismiss
    case open(RouteData)
    case didRoute(RouteData)
    
}

struct Environment {
    
}

// 3-) - HomeRouter: Each class conforming to NavigationRoutable can be considered as a RouteNode, which implements its own dedicated setup and reset functions and contains a Presenter that delegates the navigation between the screens of a RouteNode.
final class HomeRouter: NSObject {
    
    // MARK: - Properties
    
    let presenter: NavigationPresenter
    let reducer = Reducer<State, Action, Environment> { state, action, environment in
        switch action {
        case .dismiss:
            return Result.Publisher(Action.didRoute(RouteData(path: .home)))
                .eraseToAnyPublisher()
                .eraseToEffect()
        case .open(let path):
            return state.router.route(to: path)
                .map { _ in Action.didRoute(path) }
                .eraseToAnyPublisher()
                .eraseToEffect()
                
        case .didRoute(let path): return .none
        }
    }
    
//    lazy var store = Store(initialState: State(router: self), reducer: reducer, environment: Environment())

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
                let viewModel = HomeViewModel(store: HomeStore(initialState: State(router: self),
                                                               reducer: reducer, environment: Environment()))
                let viewController = HomeViewController(viewModel: viewModel)
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
