//
//  InvestmentsViewController.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 02/01/2021.
//

import UIKit

class InvestmentsViewController: UIViewController {

    weak var router: NavigationRoutable?
    
    // MARK: - Initializer
    
    init(title: String, router: NavigationRoutable) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .brown
        
    }
  
}
