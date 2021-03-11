//
//  GlobalStore.swift
//  ProjectMercury
//
//  Created by George Quentin on 11/03/2021.
//

import ComposableArchitecture
import Foundation

protocol GlobalEnvironment {
    var router: Router { get }
}

final class GlobalStore {
    
    // MARK: - Properties
    
    typealias Value = Store<State, Action>
    typealias StoreModel = ViewStore<State, Action>
    let storeModel: StoreModel
    let state: State
    private let value: Value

    // MARK: - State
    
    struct State: Equatable {
        var currentPath: AppPath?
    }

    // MARK: - Action
    
    enum Action {
        case route(to: RouteData)
        case didRoute
        case dismiss
        case didDismiss
        case dismissAndRoute(to: RouteData)
        case didDismissAndRoute
    }

    // MARK: - Environment
    
    struct Environment: GlobalEnvironment {
        var router: Router
    }
    
    // MARK: - Reducer
    
    let reducer: Reducer<State, Action, GlobalEnvironment> = .combine(
        Reducer<State, Action, GlobalEnvironment> { state, action, environment in
            switch action
            {
            case .route(let data):
                state.currentPath = data.path
                return environment.router.route(to: data)
                    .map { Action.didRoute }
                    .eraseToAnyPublisher()
                    .eraseToEffect()
            
            case .dismiss:
                state.currentPath = nil
                return environment.router.dismiss()
                    .map { Action.didDismiss }
                    .eraseToAnyPublisher()
                    .eraseToEffect()

            case .dismissAndRoute(let data):
                state.currentPath = data.path
                return environment.router.dismissAndRoute(to: data)
                    .map { Action.didDismissAndRoute }
                    .eraseToAnyPublisher()
                    .eraseToEffect()
            default:
                return .none
            }
            
        }
    )
    
    // MARK: - Initialiser
    
    init(router: Router) {
        self.state = .init()
        self.value = Value(initialState: state, reducer: reducer, environment: Environment(router: router))
        self.storeModel = StoreModel(value)
    }
}

