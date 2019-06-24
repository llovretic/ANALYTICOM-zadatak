//
//  Coordinator.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import UIKit
public protocol Coordinator: class{
    var childCoordinators: [Coordinator] { get set}
    var presenter: UINavigationController { get}
    func start()
}

public extension Coordinator {
    func addChildCoordinator(childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }

    func removeChildCoordinator(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
    
    func setupBackButton(){
        presenter.navigationBar.backItem?.title = ""
    }
    
}
