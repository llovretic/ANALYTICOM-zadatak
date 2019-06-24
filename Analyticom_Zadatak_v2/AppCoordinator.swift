//
//  AppCoordinator.swift
//  Analyticom_Zadatak_v2
//
//  Created by Luka Lovretic on 24/06/2019.
//  Copyright © 2019 llovretic. All rights reserved.
//

import UIKit
import RxSwift

class AppCoordinator: Coordinator{
    
    var childCoordinators: [Coordinator] = []
    let window: UIWindow
    //root navigation controller
    var presenter: UINavigationController
    //observable for opening notifications.
    
    init(window: UIWindow) {
        self.window = window
        presenter = UINavigationController()
    }
    
    func start() {
        window.rootViewController = presenter
        window.makeKeyAndVisible()
        presenter.navigationItem.backBarButtonItem?.title = ""
        let homeCoordinator = HomeCoordinator(presenter: presenter)
        addChildCoordinator(childCoordinator: homeCoordinator)
        homeCoordinator.start()
    }
}
