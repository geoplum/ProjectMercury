//
//  TabBarEmbeddable.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 13/12/2020.
//

import UIKit

public protocol TabBarEmbeddable: AnyObject {
    
    func didEmbedIn(tabBar: UITabBar)
}
