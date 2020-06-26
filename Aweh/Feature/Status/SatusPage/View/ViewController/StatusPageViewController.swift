//
//  StatusViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/23.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class StatusPageViewController: UIPageViewController {
    
    weak var coordinator: StatusCoordinator?
    var presenter: StatusPresenter!
    
    let statusIndicatorView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.title
        statusIndicatorView.backgroundColor = .blue
        let bar = navigationController!.navigationBar
        bar.addSubview(statusIndicatorView)
        statusIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        statusIndicatorView.bottomAnchor.constraint(equalTo: bar.topAnchor).isActive = true
        statusIndicatorView.leadingAnchor.constraint(equalTo: bar.leadingAnchor).isActive = true
        statusIndicatorView.widthAnchor.constraint(equalTo: bar.widthAnchor).isActive = true
        statusIndicatorView.bottomAnchor.constraint(equalTo: bar.topAnchor).isActive = true
        statusIndicatorView.heightAnchor
            .constraint(equalToConstant: 16)
            .isActive = true
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusIndicatorView.removeFromSuperview()
    }
}
