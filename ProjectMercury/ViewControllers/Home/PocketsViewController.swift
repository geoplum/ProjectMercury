//
//  PocketsViewController.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 02/01/2021.
//

import UIKit

final class PocketsViewController: UIViewController {

    // 5) all our view controllers need a way to talk to their coordinator/router. For larger apps you’ll want to use protocols here so that you can call the exact properties of the coordinator which will handle the routing for you.
    weak var router: Router?
    
    // MARK: - Initializer
    
    init(router: Router) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
        self.title = "Pockets"
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange
        
    }
  
}
