//
//  CashbackDetailViewController.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 02/01/2021.
//

import UIKit
import Combine

final class CashbackDetailViewController: UIViewController {

    weak var router: Router?
    private var disposables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(router: Router) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
        self.title = "Cashback Detail"
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
        
        // Pockets button
        let pocketsButton = UIButton(type: .roundedRect)
        pocketsButton.backgroundColor = .black
        pocketsButton.setTitle("Pockets", for: .normal)
        pocketsButton.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(pocketsButton)
        pocketsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pocketsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            pocketsButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            pocketsButton.widthAnchor.constraint(equalToConstant: 150),
            pocketsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        pocketsButton.tapPublisher
            .sink { [weak self] _ in
                self?.router?.route(to: RouteData(path: .pockets), animated: true, completion: nil)
            }.store(in: &disposables)
    }

}
