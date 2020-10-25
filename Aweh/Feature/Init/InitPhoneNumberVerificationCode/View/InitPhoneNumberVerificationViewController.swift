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
    
    var otpPinCode: UITextField = UITextField()
    var headerExplainerTextLabel: UILabel = UILabel()
    var continueButton = UIButton()
    var resendButton = UIButton()
    var actionButtonStackView = UIStackView()
    
    
    let spacing = 30
    let placeHolderText = "-"
    let count = 6
    
    var coordinator: InitScreensCoordinator!
    var presenter: InitPhoneNumberVerificationPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf()
        configureHeaderExplainerTextLabel()
        configureOtpPinCodetextField()
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
        headerExplainerTextLabel.autoresizingOff()
        view.addSubview(headerExplainerTextLabel)
        headerExplainerTextLabel.topAnchor --> view.topAnchor
        headerExplainerTextLabel.leadingAnchor --> view.leadingAnchor
        headerExplainerTextLabel.trailingAnchor --> view.trailingAnchor
        headerExplainerTextLabel.addDividerLine(to: [.bottom])
    }
    
    private func configureOtpPinCodetextField() {
        otpPinCode.textAlignment = .center
        otpPinCode.textContentType = .oneTimeCode
        let spacingAttribues: [NSAttributedString.Key: Any] = [.kern: spacing]
        let mutableAttributedString = NSAttributedString(string: createPlaceHolderText(), attributes: spacingAttribues)
        otpPinCode.attributedText = mutableAttributedString
        otpPinCode.autoresizingOff()
        view.addSubview(otpPinCode)
        otpPinCode.leadingAnchor --> view.leadingAnchor
        otpPinCode.trailingAnchor --> view.trailingAnchor
        otpPinCode.topAnchor --> headerExplainerTextLabel.bottomAnchor
        otpPinCode.addDividerLine(to: [.bottom])
    }
    
    private func configureActionButtons() {
        resendButton.autoresizingOff()
        continueButton.autoresizingOff()
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
        actionButtonStackView.topAnchor --> otpPinCode.bottomAnchor
    }

    
    private func createPlaceHolderText() -> String {
        var string = ""
        for i in 0..<count {
            if i == (count / 2) {
                string += ""
            } else {
                string += placeHolderText
            }
        }
        string += placeHolderText
        return string
    }
    
}


