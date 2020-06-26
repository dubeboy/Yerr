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
    var navigationController: UINavigationController { get }

    func start() -> Self
    func pop()
    func dismiss()
}

// TODO:  make this an abstract class
// TODO: This class should also hide the navigation bar if its not the main navigation
open class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
  
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    let tabBarController: UITabBarController
    
    init(_ tabBarController: UITabBarController) {
        navigationController = UINavigationController()
        self.tabBarController = tabBarController
    }
    
    /// Default Implementation does nothing
    func start() -> Self {
        return self
    }
    
    func childDidFinish(child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
    }
    
    open func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        // means we are pushing a view Controller
        guard let fromViewController = navigationController.transitionCoordinator?.viewController(forKey: .from) else { return }
        
        // this means that we already have the view on the stack probably
        if navigationController.viewControllers.contains(fromViewController) {
            return
        }
        
        // means we are poping view Controller
        
//        childDidFinish(child: fromViewController as! Coordinator) // how do we make the poped to view controller do some action // might also pass the delegate!
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    func dismiss() {
        navigationController.dismiss(animated: true, completion: nil)
    }
}

class HomeCoordinator: MainCoordinator {
    override func start() -> Self {
        navigationController.delegate = self
        let mainViewController = FeedViewController.instantiate()
        mainViewController.coordinator = self
        navigationController.tabBarItem = UITabBarItem(title: "Feed", image: nil, selectedImage: nil)
        navigationController.pushViewController(mainViewController, animated: true)
        return self
    }
}

class StatusCoordinator: MainCoordinator {
    override func start() -> Self {
        navigationController.delegate = self
        let mainViewController = InterestsViewController.instantiate()
        mainViewController.coordinator = self
        navigationController.tabBarItem = UITabBarItem(title: "Status", image: nil, selectedImage: nil)
        navigationController.pushViewController(mainViewController, animated: true)
        return self
    }
}

class ProfileCoordinator: MainCoordinator {
    override func start() -> Self {
        navigationController.delegate = self
        let mainViewController = FeedViewController.instantiate()
        
        navigationController.tabBarItem = UITabBarItem(title: "Profile", image: nil, selectedImage: nil)
        navigationController.pushViewController(mainViewController, animated: true)
        return self
    }
}
//let navControllerHome = UINavigationController()
//let navControllerNotification = UINavigationController()
//let navControllerProfile = UINavigationController()

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
