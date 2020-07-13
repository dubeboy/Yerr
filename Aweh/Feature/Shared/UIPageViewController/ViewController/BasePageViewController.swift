//
//  BasePageViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/13.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit
// TODO: BasePageViewController
protocol BasePageViewControllerDataSource: UIPageViewControllerDataSource {
    associatedtype T: BasePageablePresenter
    var presenter: T { get }
}


protocol BasePageViewController: UIPageViewController, BasePageViewControllerDataSource {
    var currentIndex: Int { get set }
    var pendingIndex: Int { get set }
}

extension BasePageViewController {
    // TODO maybe make u a type of T.T
    func viewControllerBefore<U: UIViewController>(viewController: U) -> UIViewController? {
        guard let viewControllerIndex = presenter.indexOf(
            viewController: viewController as! T.T
        ), viewControllerIndex != 0
        else {
            return nil
        }
        let previousIndex = abs((viewControllerIndex - 1) % presenter.currentPagesCount())
        return presenter.viewController(at: previousIndex)
    }
    
    func viewControllerAfter<U: UIViewController>(viewController: U) -> UIViewController? {
        guard
            let viewControllerIndex = presenter.indexOf(
                viewController: viewController as! T.T
            ),
            viewControllerIndex != presenter.currentPagesCount() - 1
        else {
            return nil
        }
        let nextIndex = abs((viewControllerIndex + 1)  % presenter.currentPagesCount())
        return presenter.viewController(at: nextIndex)
    }
    
//    func transition(completed: Bool) {
//        if completed {
//            currentIndex = pendingIndex
//            if let index = currentIndex {
//                statusView.setCurrentStatusAt(statusIndex: index)
//            }
//        }
//    }
//    
//    func willTransition() {
//        pendingIndex = presenter.indexOf(viewController: pendingViewControllers.first as! T.T)
//    }
}
