//
//  StatusViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/23.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class StatusPageViewController: UIPageViewController {
    
    weak var coordinator: SingleStatusCoordinator?
    var presenter: StatusPagePresenter!
    
    private var pendingIndex: Int?
    var currentIndex: Int?
    
    private var statusView: StatusIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: nil)
        
        createPageViewControllers(page: presenter.currentPagesCount())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(T##hidden: Bool##Bool, animated: T##Bool) // this is the way forward
        navigationController?.hidesBarsOnTap = false // TODO: - removec
        let bar = navigationController!.navigationBar
        bar.isTranslucent = true
        bar.alpha = 0.5 // TODO: - not right
        
        setupStatusIndicatorView(bar: bar, itemCount: presenter.currentPagesCount())
        
        dataSource = self
        delegate = self
    }


    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusView.removeFromSuperview()
        navigationController?.hidesBarsOnTap = false
        navigationController?.navigationBar.isTranslucent = false
    }
    
    
    func setViewModel(viewModel: StatusPageViewModel) {
        presenter.setViewModel(viewModel: viewModel)
    }
    
    func resetView() {
        // show a loader of some sort
    }
}

// MARK: DataSource

extension StatusPageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let viewControllerIndex = presenter.indexOf(
            viewController: viewController as! SingleStatusViewController
        ), viewControllerIndex != 0
        else {
            return nil
        }
        let previousIndex = abs((viewControllerIndex - 1) % presenter.currentPagesCount())
        return presenter.viewController(at: previousIndex)
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard
            let viewControllerIndex = presenter.indexOf(
                viewController: viewController as! SingleStatusViewController
            ),
            viewControllerIndex != presenter.currentPagesCount() - 1
        else {
            return nil
        }
        let nextIndex = abs((viewControllerIndex + 1)  % presenter.currentPagesCount())
        return presenter.viewController(at: nextIndex)
    }
    
    
}

// MARK: Delegate

extension StatusPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        if completed {
            currentIndex = pendingIndex
            if let index = currentIndex {
                statusView.setCurrentStatusAt(statusIndex: index)
            }
        }
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingIndex = presenter.indexOf(viewController: pendingViewControllers.first as! SingleStatusViewController)
    }
}

// MARK: pager timout delegate

extension StatusPageViewController: StatusTimoutDelegate {
    func timeout() {
        if let currentIndex = currentIndex {
            guard let viewController = presenter.viewController(at: currentIndex + 1) else { return }
            statusView.setCurrentStatusAt(statusIndex: currentIndex + 1)
            setViewControllers([viewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

// MARK: Helper functions

extension StatusPageViewController {
    
    private func setupStatusIndicatorView(bar: UINavigationBar, itemCount: Int) {
        statusView = StatusIndicator(delegate: self)
        bar.addSubview(statusView)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView.bottomAnchor.constraint(equalTo: bar.topAnchor, constant: 0).isActive = true
        statusView.leadingAnchor --> bar.leadingAnchor + 8
        statusView.trailingAnchor --> bar.trailingAnchor + -8
        statusView.centerYAnchor --> bar.centerYAnchor
        statusView.centerXAnchor --> bar.centerXAnchor
        statusView.heightAnchor --> 16
    }
    
    private func createPageViewControllers(page: Int) {
        presenter.getUserStatus(
            page: page) { [weak self] userViewModel in
            guard
                let self = self,
                let coordinator = self.coordinator
            else { return }
            //            let singleStatusViewControllers = userViewModel.statuses.map(
            //                coordinator
            //                .createSingleStatusViewController(_:)
            //            )
            //            self.presenter.setViewControllers(singleStatusViewControllers)
            //            self.setViewControllers(
            //                [singleStatusViewControllers[0]],
            //                direction: .forward,
            //                animated: true,
            //                completion: nil
            //            )
        }
    }
}
