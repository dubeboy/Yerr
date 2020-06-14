//
//  BaseCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/08.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit
import Foundation

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set}

    func start()
    func pop()
}

// make this an abstract class
class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        let mainViewController = FeedViewController.instantiate()
        mainViewController.coordinator = self
        navigationController.pushViewController(mainViewController, animated: true)
    }
    
    func childDidFinish(child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        // means we are pushing a view Controller
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        // this means that we already have the view on the stack probably
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        // means we are poping view Controller
       
//       childDidFinish(child: fromViewController) // how do we make the poped to view controller do some action // might also pass the delegate!
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
}

//protocol Coordinatable: AnyObject {
//    var coordinator: Coordinator? { get set }
//}

//extension Coordinator {
//    func startViewController<T: UIViewController>(viewController: T.Type) where T: Coordinatable {
//        let viewController = T.instantiate()
//        viewController.coordinator = self
//        navigationController.present(viewController, animated: true, completion: nil)
//    }
//}
