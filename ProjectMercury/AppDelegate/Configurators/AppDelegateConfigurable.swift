//
//  AppDelegateConfigurable.swift
//  ProjectMercury
//
//  Created by GEORGE QUENTIN on 12/12/2020.
//

import UIKit

protocol AppDelegateConfigurable: class {

    func configure(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
}
