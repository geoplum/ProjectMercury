//
//  AppPath.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 12/12/2020.
//

import UIKit

enum AppPath {
    
    // MARK: - Cases
    
    case home
    case lostMoney
    case lostMoneyDetail
    case cashback
    case cashbackDetail
    case pockets
    case investments(String)
    case inviteFriends
    case alert(UIAlertController)
    
    case unknown(component: String)
    
    // MARK: - Initialiser
    
    init?(pathComponents: [String], query: [String: String]) {
        if let firstComponent = pathComponents.first {
            switch firstComponent {
            case "home": self = .home
            case "lost-money": self = .lostMoney
            case "lost-money-detail": self = .lostMoneyDetail
            case "cashback": self = .cashback
            case "cashback-detail": self = .cashbackDetail
            case "pockets": self = .pockets
            case "investments":
//                "www.plum.com/hom/investments?fund_name=tech-giants"
                if pathComponents.count > 1, let name = pathComponents[safe: 1] {
                    self = .investments(name)
                } else if let name = query["fund_name"] {
                    self = .investments(name)
                } else { return nil }
            default:
                guard let lastComponent = pathComponents.last else { return nil }
                self = .unknown(component: lastComponent)
            }
        } else {
            self = .home
        }
    }
    
}


// MARK: - Equatable

extension AppPath: Equatable
{
    static func ==(lhs: AppPath, rhs: AppPath) -> Bool
    {
        switch (lhs, rhs)
        {
        case (.home, .home),
             (.lostMoney, .lostMoney),
             (.lostMoneyDetail, .lostMoneyDetail),
             (.cashback, .cashback),
             (.cashbackDetail, .cashbackDetail), (.pockets, .pockets):
            return true
        case (.investments(let left), investments(let right)):
            return left == right
        default:
            return false
        }
    }
}
