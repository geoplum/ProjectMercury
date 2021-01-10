//
//  Redux.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 02/01/2021.
//

import Combine
import Foundation

// Various protocols and base classes for a bare simple Redux implementation

protocol Action {}

protocol State {}

typealias Reducer<T: State> = (T, Action) -> T

typealias Dispatcher = (Action) -> Void

typealias Middleware<T: State> = (T, Action, Dispatcher?) -> Void

protocol Store: ObservableObject {
    associatedtype T: State

    var middlewares: [Middleware<T>] { get }
    var reducers: [Reducer<T>] { get }

    func dispatch(action: Action)
    func current() -> T
}

class BaseStore<T: State>: Store {

    @Published private var state: T

    let middlewares: [Middleware<T>]
    let reducers: [Reducer<T>]

    init(reducers: [Reducer<T>], initial state: T, middlewares: [Middleware<T>] ) {
        self.reducers = reducers
        self.state = state
        self.middlewares = middlewares
    }

    func dispatch(action: Action) {
        state = reducers.reduce(state) { (newState, reducer) -> T in
            return reducer(newState, action)
        }

        middlewares.forEach { middleware in
            middleware(state, action, dispatch)
        }
    }

    func current() -> T { state }
}




