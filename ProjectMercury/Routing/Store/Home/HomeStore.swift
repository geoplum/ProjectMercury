//
//  HomeStore.swift
//  ProjectMercury
//
//  Created by George Quentin on 10/01/2021.
//

import ComposableArchitecture
import Foundation
import Combine

class HomeStore: ObservableObject {
    
    @Published private(set) var state: State
    public let environment: Environment
    private let reducer: Reducer<State, Action, Environment>
    private var cancellables: Set<AnyCancellable> = []
    
    public init(
        initialState: State,
        reducer: Reducer<State, Action, Environment>,
        environment: Environment
    ) {
        self.state = initialState
        self.reducer = reducer
        self.environment = environment
    }

    public func send(_ event: Action) {
        let effect = reducer.run(&state, event, environment)
        effect
            .sink(receiveValue: send)
            .store(in: &cancellables)
    }
}
