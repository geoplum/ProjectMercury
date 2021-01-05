//
//  InviteFriendsViewController.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 02/01/2021.
//

import UIKit
import Combine

class InviteFriendsViewController: UIViewController {

    weak var router: NavigationRoutable?
    private var disposables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(router: NavigationRoutable) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
        self.title = "Invite"
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .purple
        
        // Cashback detail button
        let homeButton = UIButton(type: .roundedRect)
        homeButton.backgroundColor = .black
        homeButton.setTitle("Home", for: .normal)
        homeButton.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(homeButton)
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            homeButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            homeButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            homeButton.widthAnchor.constraint(equalToConstant: 150),
            homeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        homeButton.tapPublisher
            .sink { [weak self] _ in
                self?.router?.dismissPresentedViewControllerAndRoute(to: RouteData(path: .home), animated: true, completion: nil)
            }.store(in: &disposables)
    }
  
}
