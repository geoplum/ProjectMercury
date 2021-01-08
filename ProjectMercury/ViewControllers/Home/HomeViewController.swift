//
//  HomeViewController.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 13/12/2020.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    weak var router: NavigationRoutable?
    private var disposables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(router: NavigationRoutable) {
        self.router = router
        super.init(nibName: nil, bundle: nil)
        setupTabBarItem()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        
        // Pocket button
        let pocketsButton = UIButton(type: .roundedRect)
        pocketsButton.backgroundColor = .black
        pocketsButton.setTitle("Pockets", for: .normal)
        pocketsButton.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(pocketsButton)
        pocketsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pocketsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            pocketsButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -100),
            pocketsButton.widthAnchor.constraint(equalToConstant: 100),
            pocketsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        pocketsButton.tapPublisher
            .sink { [weak self] _ in
                self?.router?.route(to: RouteData(path: .pockets), animated: true, completion: nil)
            }.store(in: &disposables)
        
        
        // Investments button
        let investmentsButton = UIButton(type: .roundedRect)
        investmentsButton.backgroundColor = .black
        investmentsButton.setTitle("Investments", for: .normal)
        investmentsButton.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(investmentsButton)
        investmentsButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            investmentsButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            investmentsButton.topAnchor.constraint(equalTo: pocketsButton.bottomAnchor, constant: 20),
            investmentsButton.widthAnchor.constraint(equalToConstant: 100),
            investmentsButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        investmentsButton.tapPublisher
            .sink { [weak self] _ in
                self?.router?.route(to: RouteData(path: .investments("Tech Giants")), animated: true, completion: nil)
            }.store(in: &disposables)
        
        // Cashback button
        let cashbackButton = UIButton(type: .roundedRect)
        cashbackButton.backgroundColor = .black
        cashbackButton.setTitle("Cashback", for: .normal)
        cashbackButton.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(cashbackButton)
        cashbackButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cashbackButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            cashbackButton.topAnchor.constraint(equalTo: investmentsButton.bottomAnchor, constant: 20),
            cashbackButton.widthAnchor.constraint(equalToConstant: 100),
            cashbackButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        cashbackButton.tapPublisher
            .sink { [weak self] _ in
                self?.router?.route(to: RouteData(path: .cashback), animated: true, completion: nil)
            }.store(in: &disposables)
        
        // Lost money button
        let lostmoneyButton = UIButton(type: .roundedRect)
        lostmoneyButton.backgroundColor = .black
        lostmoneyButton.setTitle("Lost money", for: .normal)
        lostmoneyButton.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(lostmoneyButton)
        lostmoneyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lostmoneyButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            lostmoneyButton.topAnchor.constraint(equalTo: cashbackButton.bottomAnchor, constant: 20),
            lostmoneyButton.widthAnchor.constraint(equalToConstant: 100),
            lostmoneyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        lostmoneyButton.tapPublisher
            .sink { [weak self] _ in
                self?.router?.route(to: RouteData(path: .lostMoney), animated: true, completion: nil)
            }.store(in: &disposables)
        
        // Invite button
        let inviteButton = UIButton(type: .roundedRect)
        inviteButton.backgroundColor = .black
        inviteButton.setTitle("Invite", for: .normal)
        inviteButton.setTitleColor(UIColor.white, for: .normal)
        self.view.addSubview(inviteButton)
        inviteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inviteButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            inviteButton.topAnchor.constraint(equalTo: lostmoneyButton.bottomAnchor, constant: 20),
            inviteButton.widthAnchor.constraint(equalToConstant: 100),
            inviteButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        inviteButton.tapPublisher
            .sink { [weak self] _ in
                self?.router?.route(to: RouteData(path: .inviteFriends), animated: true, completion: nil)
            }.store(in: &disposables)
    }
    
    // MARK: - UI Setup
    
    private func setupTabBarItem() {
        title = "Home"
        tabBarItem.image = UIImage(systemName: "house")?.withRenderingMode(.alwaysTemplate)
        tabBarItem.selectedImage = UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysOriginal)
    }
    
}
