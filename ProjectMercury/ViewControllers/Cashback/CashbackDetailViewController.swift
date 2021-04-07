//
//  CashbackDetailViewController.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 02/01/2021.
//

import UIKit
import Combine

final class CashbackDetailViewController: UIViewController {

    var storeModel: RouterStore.StoreModel?
    private var disposables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(storeModel: RouterStore.StoreModel?) {
        self.storeModel = storeModel
        super.init(nibName: nil, bundle: nil)
        self.title = "cashback_detail_title".localized
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
        pocketsButton.setTitle("pockets".localized, for: .normal)
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
                self?.storeModel?.send(.route(to: RouteData(path: .pockets)))
            }.store(in: &disposables)
    }

}
