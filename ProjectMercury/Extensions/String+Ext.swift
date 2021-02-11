//
//  String+Ext.swift
//  ProjectMercury
//
//  Created by George Quentin on 11/02/2021.
//

import Foundation
import UIKit

extension String {
    
    // MARK: - Localization
    
    public var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}
