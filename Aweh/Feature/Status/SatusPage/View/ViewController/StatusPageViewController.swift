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
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("ViewWill Apear")
//        navigationController?.setNavigationBarHidden(T##hidden: Bool##Bool, animated: T##Bool)
        navigationController?.hidesBarsOnTap = true // TODO: - removec
        let bar = navigationController!.navigationBar
        bar.isTranslucent = true
        
//        bar.alpha =
        setupStatusIndicatorView(bar: bar)
        setupStatusView(with: 1)
    }
    
    
    private func setupStatusIndicatorView(bar: UINavigationBar) {
        bar.addSubview(statusIndicatorView)
        statusIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        statusIndicatorView.bottomAnchor.constraint(equalTo: bar.topAnchor, constant: 8).isActive = true
        statusIndicatorView.leadingAnchor --> bar.leadingAnchor
        statusIndicatorView.trailingAnchor --> bar.trailingAnchor
        statusIndicatorView.widthAnchor --> bar.widthAnchor
        statusIndicatorView.heightAnchor --> 16
    }
    
    private func setupStatusView(with itemCount: Int) {
        let statusView = StatusIndicator(itemCount: itemCount)
        statusIndicatorView.addSubview(statusView)
        statusView.translatesAutoresizingMaskIntoConstraints = false
        statusView --> statusIndicatorView  // TODO: something is wrong
    }
    
    private func createPageViewControllers() -> [SingleStatusViewController] {
//        for
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusIndicatorView.removeFromSuperview()
        navigationController?.hidesBarsOnTap = false
        navigationController?.navigationBar.isTranslucent = false
    }
}
