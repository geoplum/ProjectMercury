//
//  UIControl.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 02/01/2021.
//

import UIKit
import Combine

extension UIButton {
    
    var tapPublisher: EventPublisher {
        return publisher(for: .touchUpInside)
    }
}

extension UITextField {
    
    var textPublisher: AnyPublisher<String, Never> {
        publisher(for: .editingChanged)
            .map { self.text ?? "" }
            .eraseToAnyPublisher()
    }
}
