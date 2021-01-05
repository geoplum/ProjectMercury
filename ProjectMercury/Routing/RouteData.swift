//
//  RouteData.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 12/12/2020.
//

import Foundation

struct AppPathParameters<Value> {
    private let data: [String : Value]
    
    init(_ data: [String : Value]) {
        self.data = data
    }
    
    public subscript(dynamicMember member: String) -> Value? {
        return data[member]
    }
}

struct RouteData {
    let path: AppPath
    let parameters: AppPathParameters<String>
    
    init(path: AppPath, parameters: [String: String] = [:]) {
        self.path = path
        self.parameters = AppPathParameters(parameters)
    }
}
