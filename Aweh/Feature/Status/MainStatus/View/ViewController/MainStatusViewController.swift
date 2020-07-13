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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView = createUISegmentView()
    }
    
    private func createUISegmentView() -> UISegmentedControl {
        let segmentedControl = UISegmentedControl(items: ["Status", "Replies"])
        segmentedControl.addTarget(
            self,
            action: #selector(valueChanged),
            for: .valueChanged
        )
        return segmentedControl
    }
    
    @objc private func valueChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        let viewControllers = presenter.viewControllersPresenters(at: selectedIndex)
        
        switch viewControllers {
            case .interests(_):
                let viewController = coordinator.createInterestViewController(
                    presenter: InterestsPresenterImplemantation()
                )
                viewController.remove()
                add(viewController)
                presenter.setIsInMemory(at: selectedIndex)
            case .replies(_):
                let viewController = UIViewController()
                viewController.view.backgroundColor = UIColor.red
                viewController.remove()
                add(viewController)
                presenter.setIsInMemory(at: selectedIndex)
        }
    }
}
