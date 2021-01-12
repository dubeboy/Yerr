//
//  MainStatus.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/13.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class MainStatusViewController: UIPageViewController {
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
    
    @objc private func valueChanged(sender: UISegmentedControl) {
        
    }
}
