//
//  InvestmentsViewController.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 02/01/2021.
//

import UIKit
import Combine

class InvestmentsViewController: UIViewController {

    weak var router: NavigationRoutable?
    private var disposables = Set<AnyCancellable>()
    
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
        
        // Invite button
        let inviteButton = UIButton(type: .roundedRect)
        inviteButton.backgroundColor = .black
        inviteButton.setTitle("Invite", for: .normal)
        inviteButton.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(inviteButton)
        inviteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inviteButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            inviteButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            inviteButton.widthAnchor.constraint(equalToConstant: 100),
            inviteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        inviteButton.tapPublisher
            .sink { [weak self] _ in
                self?.router?.route(to: RouteData(path: .inviteFriends), animated: true, completion: nil)
            }.store(in: &disposables)
    }
  
}
