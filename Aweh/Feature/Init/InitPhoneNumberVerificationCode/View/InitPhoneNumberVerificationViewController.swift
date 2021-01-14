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
    
    
    var coordinator: InitScreensCoordinator!
    var presenter: InitPhoneNumberVerificationPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.hidesBackButton = true
        configureSelf()
        configureHeaderExplainerTextLabel()
        configureOTPView()
        configureActionButtons()
    }
    
    
    @objc func continueButtonTapped() {
        coordinator.startInfoInputViewController()
    }
    
    @objc func resendButtonTapped() {
        
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
        resendButton.addTarget(self, action: #selector(resendButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        resendButton.setTitleColor(Const.Color.InitInfoInput.resendColor, for: .normal)
        continueButton.setTitleColor(Const.Color.InitInfoInput.resendColor, for: .normal)
        resendButton.setTitle(presenter.resendButtonTitle, for: .normal)
        continueButton.setTitle(presenter.continueButtonTitle, for: .normal)

        actionButtonStackView.autoresizingOff()
        actionButtonStackView.alignment = .center
        actionButtonStackView.distribution = .fillEqually
        actionButtonStackView.axis = .vertical
        actionButtonStackView.addArrangedSubview(resendButton)
        actionButtonStackView.addArrangedSubview(continueButton)
        view.addSubview(actionButtonStackView)
        actionButtonStackView.leadingAnchor --> view.leadingAnchor
        actionButtonStackView.trailingAnchor --> view.trailingAnchor
        actionButtonStackView.topAnchor --> otpView.bottomAnchor + Const.View.m8
    }
    
}
