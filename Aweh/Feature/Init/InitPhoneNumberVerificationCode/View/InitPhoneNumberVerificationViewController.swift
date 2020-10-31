//
//  InitPhoneNumberVerificationViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit


// TODO: put this inside a UIScrollView
class InitPhoneNumberVerificationViewController: UIViewController {
    
    var otpView = OTPView()
    
    var headerExplainerTextLabel: UILabel = UILabel()
    var continueButton = YerrButton()
    var resendButton = YerrButton()
    var actionButtonStackView = UIStackView()
    
    let spacing = 10
    let placeHolderText = "-"
    let count = 6
    
    var coordinator: InitScreensCoordinator!
    var presenter: InitPhoneNumberVerificationPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureSelf()
        configureHeaderExplainerTextLabel()
        configureOTPView()
        configureActionButtons()
    }
    
}

// MARK: Helper functions
extension InitPhoneNumberVerificationViewController {
    private func configureSelf() {
        
    }
    
    private func configureHeaderExplainerTextLabel() {
        headerExplainerTextLabel.textAlignment = .center
        headerExplainerTextLabel.text = presenter.headerText
        headerExplainerTextLabel.numberOfLines = 0
        headerExplainerTextLabel.lineBreakMode = .byWordWrapping
        headerExplainerTextLabel.autoresizingOff()
        view.addSubview(headerExplainerTextLabel)
        headerExplainerTextLabel.topAnchor --> view.safeAreaLayoutGuide.topAnchor + Const.View.m16
        headerExplainerTextLabel.leadingAnchor --> view.leadingAnchor + Const.View.m16
        headerExplainerTextLabel.trailingAnchor --> view.trailingAnchor + -Const.View.m16
    }
    
    private func configureOTPView() {
        otpView.autoresizingOff()

        view.addSubview(otpView)
//        otpView.leadingAnchor --> view.leadingAnchor
//        otpView.trailingAnchor --> view.trailingAnchor
        otpView.centerXAnchor --> view.centerXAnchor
        otpView.topAnchor --> headerExplainerTextLabel.bottomAnchor + Const.View.m16
        otpView.addDividerLine(to: [.bottom, .top])
    }
    
    private func configureActionButtons() {
        resendButton.autoresizingOff()
        continueButton.autoresizingOff()
        resendButton.setTitle(presenter.resendButtonTitle, for: .normal)
        continueButton.setTitle(presenter.continueButtonTitle, for: .normal)
        resendButton.setTitleColor(Const.Color.label, for: .normal)
        continueButton.setTitleColor(Const.Color.label, for: .normal)

        actionButtonStackView.autoresizingOff()
        actionButtonStackView.alignment = .center
        actionButtonStackView.distribution = .fillEqually
        actionButtonStackView.axis = .vertical
        actionButtonStackView.addArrangedSubview(resendButton)
        actionButtonStackView.addArrangedSubview(continueButton)
        view.addSubview(actionButtonStackView)
        actionButtonStackView.leadingAnchor --> view.leadingAnchor
        actionButtonStackView.trailingAnchor --> view.trailingAnchor
//        actionButtonStackView.topAnchor --> otpPinCode.bottomAnchor + Const.View.m8
    }

    
    private func createPlaceHolderText() -> String {
        var string = ""
        for i in 0..<count {
            if i == (count / 2) {
                string += " "
            } else {
                string += placeHolderText
            }
        }
        string += placeHolderText
        return string
    }
    
}
