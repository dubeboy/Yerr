//
//  InitPhoneNumberInput.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class InitPhoneNumberInput: UIViewController {
    var topSectionLabel: UILabel = UILabel()
    var selectedButton: UIButton = UIButton()
    
    var phoneNumberSectionView: UIView = UIView()
    var phoneNumberSectionCountryCodeLabel = UILabel()
    var phoneNumberSectionInputField = UITextField()
    
    var presenter: InitPhoneNumberInputPresenter!
    // remove the previouse view from the stack
    // save this as the current position in the case that the uer  exit the app
    // log exits
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf()
    }
}

extension InitPhoneNumberInput {
    private func configureSelf() {
        configureTopSectionText()
        configureSelectedButton()
        configurePhoneNumberSectionView()
    }
    
    private func configureTopSectionText() {
        view.addSubview(topSectionLabel)
        topSectionLabel.autoresizingOff()
        topSectionLabel.text = presenter.confirmPhoneNumberText
        topSectionLabel.topAnchor --> view.topAnchor
        topSectionLabel.leadingAnchor --> view.leadingAnchor
        topSectionLabel.trailingAnchor --> view.trailingAnchor
        topSectionLabel.textAlignment = .center
        topSectionLabel.addDividerLine(to: [.bottom])
        
    }
    
    private func configureSelectedButton() {
        view.addSubview(selectedButton)
        selectedButton.autoresizingOff()
        let icon = Const.Assets.InitPhoneNumber.chevronRight
        selectedButton.setImage(icon, for: .normal)
        selectedButton.imageView?.contentMode = .scaleAspectFit
        selectedButton.leadingAnchor --> view.leadingAnchor
        selectedButton.semanticContentAttribute = .forceRightToLeft
//        selectedButton.imageEdgeInsets = UIEdgeInsets(0., selectedButton.frame.size.width - (icon.size.width + 15.), 0., 0.)
//        button.titleEdgeInsets = UIEdgeInsetsMake(0., 0., 0., image.size.width);
        selectedButton.trailingAnchor --> view.trailingAnchor
        selectedButton.topAnchor --> topSectionLabel.bottomAnchor
        selectedButton.addDividerLine(to: [.bottom])
    }
    
    private func configurePhoneNumberSectionView() {
        phoneNumberSectionView.autoresizingOff()
        configurePhoneNumberSectionCountryCode()
        configrePhoneNumberSectionInputField()
        
        
        view.addSubview(phoneNumberSectionView)
        phoneNumberSectionView.topAnchor --> selectedButton.bottomAnchor
        phoneNumberSectionView.leadingAnchor --> view.leadingAnchor
        phoneNumberSectionView.trailingAnchor --> view.trailingAnchor
        phoneNumberSectionView.addDividerLine(to: [.bottom])
        
    }
    
    private func configurePhoneNumberSectionCountryCode() {
        phoneNumberSectionCountryCodeLabel.autoresizingOff()
        phoneNumberSectionCountryCodeLabel.widthAnchor --> (Const.View.m16 * 2)
        phoneNumberSectionView.addSubview(phoneNumberSectionCountryCodeLabel)
        phoneNumberSectionCountryCodeLabel.leadingAnchor --> phoneNumberSectionView.leadingAnchor
        phoneNumberSectionCountryCodeLabel.topAnchor --> phoneNumberSectionView.topAnchor
        phoneNumberSectionCountryCodeLabel.bottomAnchor --> phoneNumberSectionView.bottomAnchor
        phoneNumberSectionCountryCodeLabel.addDividerLine(to: [.right])
    }
    
    private func configrePhoneNumberSectionInputField() {
        phoneNumberSectionInputField.autoresizingOff()
        phoneNumberSectionInputField.placeholder = presenter.phoneNumberPlaceholderText
        phoneNumberSectionView.addSubview(phoneNumberSectionInputField)
        phoneNumberSectionInputField.leadingAnchor --> phoneNumberSectionCountryCodeLabel.trailingAnchor
        phoneNumberSectionInputField.bottomAnchor --> phoneNumberSectionView.bottomAnchor
        phoneNumberSectionInputField.trailingAnchor --> phoneNumberSectionView.trailingAnchor
        phoneNumberSectionInputField.topAnchor --> phoneNumberSectionView.topAnchor
    }
}
