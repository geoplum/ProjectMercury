//
//  HomeStore.swift
//  ProjectMercury
//
//  Created by George Quentin on 10/01/2021.
//

import Foundation

struct HomeState: State {
    let isLoading: Bool
    
    static var empty: HomeState {
        HomeState(isLoading: false)
    }
}

class HomeStore: BaseStore<HomeState> {
    
 }
