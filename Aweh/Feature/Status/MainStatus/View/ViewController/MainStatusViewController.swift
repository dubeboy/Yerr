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
    
    var presenter: MainStatusPresenter!
    var coordinator: StatusCoordinator!
    
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
        let viewControllers = presenter.viewControllersPresenters()
        
        switch viewControllers {
            case .status(let status):
                if presenter.isViewInMemory(at: selectedIndex) != true {
                    let viewController = coordinator.createSingleStatusViewController(status)
                    
                    add(viewController)
                    presenter.setIsInMemory(at: selectedIndex)
                    
                }
            case .replies(_):
                break
                
        }
    }
}
