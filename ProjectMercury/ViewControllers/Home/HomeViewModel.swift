//
//  HomeViewModel.swift
//  ProjectMercury
//
//  Created by George Quentin on 10/01/2021.
//

import Combine

class HomeViewModel {
    
    // 5-) - all our view controllers need a way to talk to their coordinator/router, and the Store provides that communication.
    let storeModel: GlobalStore.StoreModel
    var disposables = Set<AnyCancellable>()
    
    init(storeModel: GlobalStore.StoreModel) {
        self.storeModel = storeModel
        self.registerObservers()
    }
    
    func registerObservers() {
        
        storeModel.publisher
            .sink { state in
                guard let path = state.currentPath else { return }
                print("Current path is", path)
                
            }.store(in: &disposables)
    }
}
