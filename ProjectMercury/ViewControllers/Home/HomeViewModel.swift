//
//  HomeViewModel.swift
//  ProjectMercury
//
//  Created by George Quentin on 10/01/2021.
//

import Foundation

class HomeViewModel {
    
    // 5-) - all our view controllers need a way to talk to their coordinator/router, and the Store provides that communication.
    let homeStore: HomeStore
    
    init(store: HomeStore) {
        self.homeStore = store
    }
}
