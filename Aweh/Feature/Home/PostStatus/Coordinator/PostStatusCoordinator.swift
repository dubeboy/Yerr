//
//  PostStatusCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/09.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

protocol PostStatusCoordinator: Coordinator {
    func startPostStatusViewController()
}

extension HomeCoordinator: PostStatusCoordinator  {
    func startPostStatusViewController() {
        let viewController = PostStatusViewController.instantiate()
        viewController.coordinator = self
//        navigationController.present(viewController, animated: true, completion: nil)
        navigationController.pushViewController(viewController, animated: true)
    }
    

//    let child = PostStatusCoordinator(navigationController: navigationController)
//    child.parentCoordinator = self
//    childCoordinators.append(child)
//    child.start()

}


