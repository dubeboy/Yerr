//
//  InitAcceptTcsAndCs.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/22.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit


class InitAcceptTcsAndCsViewController: UIViewController {
    
    var headerImageView = UIImageView()
    var tsAndCsLabel = UILabel()
    var continueButton = YerrButton(frame: .zero)
    var welcomeTitle: UILabel = UILabel()
    
    var presenter: InitAcceptTcsAndCsPresenter!
    var coordinator: InitPhoneNumberCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = presenter.title
        configureSelf()
        configureImageView()
        navigationItem.hidesBackButton = true
    }
    
    @objc func didTapContinue() {
        coordinator.startInitPhoneNumberCoordinatorViewController()
    }
}


// MARK: Private utilty functions
extension InitAcceptTcsAndCsViewController {
    private func configureSelf() {
        tsAndCsLabel.autoresizingOff()
        continueButton.autoresizingOff()
        configureButton()
        configureTsAndCsLabel()
        configureWelcomeTitle()
        view.addSubview(tsAndCsLabel)
        view.addSubview(continueButton)
        view.addSubview(welcomeTitle)
        
        continueButton.bottomAnchor --> view.safeAreaLayoutGuide.bottomAnchor + -Const.View.m16
        continueButton.centerXAnchor --> view.centerXAnchor
        
        tsAndCsLabel.bottomAnchor --> continueButton.topAnchor
        tsAndCsLabel.centerXAnchor --> view.centerXAnchor
        tsAndCsLabel.leadingAnchor --> view.leadingAnchor + Const.View.m16
        tsAndCsLabel.trailingAnchor --> view.trailingAnchor + -Const.View.m16
        
        welcomeTitle.bottomAnchor --> tsAndCsLabel.topAnchor
        welcomeTitle.centerXAnchor --> view.centerXAnchor
        welcomeTitle.leadingAnchor --> view.leadingAnchor + Const.View.m16
        welcomeTitle.trailingAnchor --> view.trailingAnchor + -Const.View.m16
    }
    
    private func configureImageView() {
        headerImageView.autoresizingOff()
        view.addSubview(headerImageView)
        headerImageView.centerXAnchor --> view.centerXAnchor
        headerImageView.topAnchor --> view.safeAreaLayoutGuide.topAnchor + (Const.View.m16 * 2)
        headerImageView.widthAnchor --> 200
        headerImageView.heightAnchor --> 200
        headerImageView.backgroundColor = .red
    }
    
    private func configureButton() {
        continueButton.setTitle(presenter.acceptTsAndCButtonTitle, for: .normal)
        continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
    }
    
    private func configureTsAndCsLabel() {
        tsAndCsLabel.lineBreakMode = .byWordWrapping
        tsAndCsLabel.numberOfLines = 0
        tsAndCsLabel.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: presenter.acceptTsText)
        let linkAttributedString = NSMutableAttributedString(string: presenter.linkToTsCs)
        linkAttributedString.addAttributes([.link: presenter.linkToTsCs], range: NSRange(location: 0, length: presenter.linkToTsCs.count))
        attributedText.append(linkAttributedString)
        tsAndCsLabel.attributedText = attributedText
       
    }
    
    private func configureWelcomeTitle() {
        welcomeTitle.autoresizingOff()
        welcomeTitle.text = presenter.welcomeTitle
        welcomeTitle.textAlignment = .center
    }
    
}
