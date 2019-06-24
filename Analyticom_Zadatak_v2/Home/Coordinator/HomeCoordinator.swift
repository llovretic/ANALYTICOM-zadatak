//
//  HomeCoordinator.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    let controller: HomeViewController
    
    init (presenter: UINavigationController){
        self.presenter = presenter
        let controller = HomeViewController()
        let viewModel = HomeViewModel()
        controller.viewModel = viewModel
        self.controller = controller
        viewModel.delegate = self
    }
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
    
    
}

extension HomeCoordinator: HomeCoordinatorDelegate{
    func openPlayersListScreen() {
        let listCoordinator = PlayersListCoordinator(presenter: presenter)
        addChildCoordinator(childCoordinator: listCoordinator)
        listCoordinator.start()
    }
    
    func openPlayerRegistrationScreen() {
        let playerRegistrationCoordinator = PlayerRegistrationCoordinator(presenter: presenter)
        addChildCoordinator(childCoordinator: playerRegistrationCoordinator)
        playerRegistrationCoordinator.start()
    }
    
    
}
