//
//  HomeViewController.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 13/12/2020.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {

    private let viewModel: HomeViewModel
    private var disposables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
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
        pocketsButton.setTitle("pockets".localized, for: .normal)
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
                self?.viewModel.homeStore.send(.open(RouteData(path: .pockets)))
            }.store(in: &disposables)
        
        
        // Investments button
        let investmentsButton = UIButton(type: .roundedRect)
        investmentsButton.backgroundColor = .black
        investmentsButton.setTitle("investments_title".localized, for: .normal)
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
                self?.viewModel.homeStore.send(.open(RouteData(path: .investments("tech_giants_title".localized))))
            }.store(in: &disposables)
        
        // Cashback button
        let cashbackButton = UIButton(type: .roundedRect)
        cashbackButton.backgroundColor = .black
        cashbackButton.setTitle("cashback_title".localized, for: .normal)
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
                self?.viewModel.homeStore.send(.open(RouteData(path: .cashback)))
            }.store(in: &disposables)
        
        // Lost money button
        let lostmoneyButton = UIButton(type: .roundedRect)
        lostmoneyButton.backgroundColor = .black
        lostmoneyButton.setTitle("lost_money_title".localized, for: .normal)
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
                self?.viewModel.homeStore.send(.open(RouteData(path: .lostMoney)))
            }.store(in: &disposables)
        
        // Invite button
        let inviteButton = UIButton(type: .roundedRect)
        inviteButton.backgroundColor = .black
        inviteButton.setTitle("invite_friend_title".localized, for: .normal)
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
                //6-) - `router.route(to:...`: all view controllers that need to communitcate with their coordinator/router to go to other screens will have this notation. The coordinator will handle these requests and show the appropriate screen depending of how the router is setup. 
                self?.viewModel.homeStore.send(.open(RouteData(path: .inviteFriends)))
            }.store(in: &disposables)
    }
    
    // MARK: - UI Setup
    
    private func setupTabBarItem() {
        title = "home_title".localized
        tabBarItem.image = UIImage(systemName: "house")?.withRenderingMode(.alwaysTemplate)
        tabBarItem.selectedImage = UIImage(systemName: "house.fill")?.withRenderingMode(.alwaysOriginal)
    }
    
}
