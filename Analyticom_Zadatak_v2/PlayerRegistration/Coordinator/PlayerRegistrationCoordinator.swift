//
//  PlayerRegistrationCoordinator.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import Foundation
import UIKit

class PlayerRegistrationCoordinator: Coordinator{
    var childCoordinators: [Coordinator] = []
    var presenter: UINavigationController
    let controller: PlayerRegistrationViewController
    
    init (presenter: UINavigationController){
        self.presenter = presenter
        let controller = PlayerRegistrationViewController()
        let viewModel = PlayerRegistrationViewModel()
        controller.viewModel = viewModel
        self.controller = controller
    }
    func start() {
        presenter.pushViewController(controller, animated: true)
    }
    
    
}
