//
//  Factory.swift
//  ProjectMercury
//
//  Created by George Quentin on 10/01/2021.
//

import Foundation

enum Factory {
    enum Reducers {}
    enum Middlewares {}
}

extension Factory.Reducers {
    static func homeReducers() -> [Reducer<HomeState>] {
        []
    }
}

extension Factory.Middlewares {
    static func homeMiddlewares() -> [Middleware<HomeState>] {
        []
    }
}
