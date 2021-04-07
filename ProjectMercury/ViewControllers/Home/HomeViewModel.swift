//
//  HomeViewModel.swift
//  ProjectMercury
//
//  Created by George Quentin on 10/01/2021.
//

import Combine

class HomeViewModel {
    
    // 5-) - all our view controllers need a way to talk to their coordinator/router, and the StoreModel provides that communication.
    var storeModel: RouterStore.StoreModel?
    
    init(storeModel: RouterStore.StoreModel?) {
        self.storeModel = storeModel
    }
    
}
