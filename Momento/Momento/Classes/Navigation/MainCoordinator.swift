//
//  MainCoordinator.swift
//  Momento
//
//  Created by Александр on 04.11.2021.
//

import Foundation
import UIKit

class MainCoordinator {

    lazy var rootNavController: UINavigationController = {
        let splashVC = UIViewController.init()
//        splashVC.view.backgroundColor = R.color.background()
        let navVC = UINavigationController(rootViewController: splashVC)
        navVC.setNavigationBarHidden(true, animated: false)
        return navVC
    }()
    
    init() {
        self.start()
    }
    
    func start() {
        rootMainController()
    }
    
    func rootMainController() {
        let mainModel = MainViewModel()
        let mainVC = MainController(viewModel: mainModel)
        rootNavController.viewControllers = [mainVC]
    }
    
}
