//
//  PlayersListCoordinator.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import Foundation
import UIKit

class PlayersListCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    let controller: PlayersListViewController
    
    init (presenter: UINavigationController){
        self.presenter = presenter
        let controller = PlayersListViewController()
        let viewModel = PlayersListViewModel()
        controller.viewModel = viewModel
        self.controller = controller
    }
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
    
    
}
