//
//  PostStatusCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/09.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

protocol PostStatusCoordinator: Coordinator {
    func startPostStatusViewController(delegate: @escaping Completion<StatusViewModel>)
}

extension HomeCoordinator: PostStatusCoordinator  {
    func startPostStatusViewController(delegate: @escaping Completion<StatusViewModel>) {
        let viewController = PostStatusViewController.instantiate()
        viewController.coordinator = self
        viewController.delegate = delegate
        viewController.presenter = PostStatusPresenterImplementation()
        let postStatusNavigationConstroller = UINavigationController(rootViewController: viewController)
        navigationController.present(postStatusNavigationConstroller, animated: true)
    }
    

//    let child = PostStatusCoordinator(navigationController: navigationController)
//    child.parentCoordinator = self
//    childCoordinators.append(child)
//    child.start()

}


