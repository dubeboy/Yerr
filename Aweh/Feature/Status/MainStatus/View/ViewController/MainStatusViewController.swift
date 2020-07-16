//
//  MainStatus.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/13.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

// this could easily be be a page viewcontroller!
class MainStatusViewController: UIViewController {
    
    var presenter: MainStatusPresenter = MainStatusPresenterImplementation()
    var coordinator: InterestCoordinator!
    var feedCoordinator: FeedCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = createUISegmentView()
        selectViewController(at: 0)
    }
    
    private func createUISegmentView() -> UISegmentedControl {
        let segmentedControl = UISegmentedControl(items: ["Status", "Replies"])
        segmentedControl.addTarget(
            self,
            action: #selector(valueChanged),
            for: .valueChanged
        )
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }
    
    @objc private func valueChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        selectViewController(at: selectedIndex)
    }
    
    private func selectViewController(at Index: Int) {
        let viewControllers = presenter.viewControllersPresenters(at: Index)
        
        switch viewControllers {
            case .interests(_):
                let viewController = coordinator.createInterestViewController(
                    presenter: InterestsPresenterImplemantation()
                )
                viewController.remove()
                add(viewController)
            case .replies(_):
                let viewController = feedCoordinator.createFeedViewController()
                viewController.remove()
                add(viewController)
        }
    }
}
