//
//  PocketsViewController.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 02/01/2021.
//

import UIKit
import ComposableArchitecture
import Combine

final class PocketsViewController: UIViewController {

    // 5-) - all our view controllers need a way to talk to their coordinator/router. For larger apps you’ll want to use protocols here so that you can call the exact properties of the coordinator which will handle the routing for you.
    var storeModel: GlobalStore.StoreModel?
    private var disposables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(storeModel: GlobalStore.StoreModel?) {
        self.storeModel = storeModel
        super.init(nibName: nil, bundle: nil)
        self.title = "pockets".localized
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .orange
        
        
        // Cashback detail button
        let lostMoneyButton = UIButton(type: .roundedRect)
        lostMoneyButton.backgroundColor = .black
        lostMoneyButton.setTitle("lost_money_detail_title".localized, for: .normal)
        lostMoneyButton.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(lostMoneyButton)
        lostMoneyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lostMoneyButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            lostMoneyButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            lostMoneyButton.widthAnchor.constraint(equalToConstant: 150),
            lostMoneyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        lostMoneyButton.tapPublisher
            .sink { [weak self] _ in
                self?.storeModel?.send(.dismissAndRoute(to: RouteData(path: .lostMoneyDetail)))
            }.store(in: &disposables)
    }
  
}
