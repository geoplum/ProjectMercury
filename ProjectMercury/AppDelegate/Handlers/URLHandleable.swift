//
//  URLHandler.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 13/12/2020.
//

import Foundation

public protocol URLHandleable {
    
    func canHandle(_ url: URL) -> Bool
    func handle(_ url: URL)
}
