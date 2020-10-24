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
    var tsAndCsButton = YerrButton(frame: .zero)
    var welcomeTitle: UILabel = UILabel()
    
    var presenter: InitAcceptTcsAndCsPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf()
        configureImageView()
    }
}


// MARK: Private utilty functions
extension InitAcceptTcsAndCsViewController {
    private func configureSelf() {
        tsAndCsLabel.autoresizingOff()
        tsAndCsButton.autoresizingOff()
        configureButton()
        configureTsAndCsLabel()
        configureWelcomeTitle()
        view.addSubview(tsAndCsLabel)
        view.addSubview(tsAndCsButton)
        view.addSubview(welcomeTitle)
        
        tsAndCsButton.bottomAnchor --> view.safeAreaLayoutGuide.bottomAnchor
        tsAndCsButton.centerXAnchor --> view.centerXAnchor
        
        tsAndCsLabel.bottomAnchor --> tsAndCsButton.topAnchor
        tsAndCsLabel.centerXAnchor --> view.centerXAnchor
        
        welcomeTitle.bottomAnchor --> tsAndCsLabel.topAnchor
        welcomeTitle.centerXAnchor --> view.centerXAnchor
    }
    
    private func configureImageView() {
        headerImageView.autoresizingOff()
        view.addSubview(headerImageView)
        headerImageView.centerYAnchor --> view.centerYAnchor
        headerImageView.topAnchor --> view.topAnchor + 100
        headerImageView.widthAnchor --> 200
        headerImageView.heightAnchor --> 200
        headerImageView.backgroundColor = .red
    }
    
    private func configureButton() {
        tsAndCsButton.setTitle(presenter.acceptTsAndCButtonTitle, for: .normal)
    }
    
    private func configureTsAndCsLabel() {
        let attributedText = NSMutableAttributedString(string: presenter.acceptTsText)
        let linkAttributedString = NSMutableAttributedString(string: presenter.linkToTsCs)
        linkAttributedString.addAttributes([.link: presenter.linkToTsCs], range: NSRange(location: 0, length: presenter.linkToTsCs.count))
        attributedText.append(linkAttributedString)
        tsAndCsLabel.attributedText = attributedText
    }
    
    private func configureWelcomeTitle() {
        welcomeTitle.autoresizingOff()
        welcomeTitle.text = presenter.welcomeTitle
    }
    
}
