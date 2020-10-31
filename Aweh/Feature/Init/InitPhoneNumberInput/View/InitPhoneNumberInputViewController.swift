//
//  InitPhoneNumberInput.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class InitPhoneNumberInputViewController: UIViewController {
    private var topSectionLabel: UILabel = UILabel()
    private var selectedButtonIcon = YerrButton()
    private var selectedButtonTitle = YerrButton()
    private var buttonSectionView: UIView = UIView()
     
    private var phoneNumberSectionView: UIView = UIView()
    private var phoneNumberSectionCountryCodeLabel = UILabel()
    private var phoneNumberSectionInputField = UITextField()
    
    var presenter: InitPhoneNumberInputPresenter!
    // remove the previouse view from the stack
    // save this as the current position in the case that the uer  exit the app
    // log exits
    
    var coordinator: InitPhoneNumberVerficationCodeCoordinator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = presenter.title
        configureSelf()
        
        navigationItem.rightBarButtonItem  = UIBarButtonItem(title: presenter.doneBarButtonItem, style: .plain, target: self, action: #selector(doneBarButtonTapped))
    }
    
    @objc func doneBarButtonTapped() {
        coordinator.startOTPViewController()
    }
}

extension InitPhoneNumberInputViewController {
    private func configureSelf() {
        configureTopSectionText()
        configureSelectedButton()
        configurePhoneNumberSectionView()
    }

    
    private func configureTopSectionText() {
        topSectionLabel.autoresizingOff()
        view.addSubview(topSectionLabel)
        topSectionLabel.autoresizingOff()
        topSectionLabel.text = presenter.confirmPhoneNumberText
        topSectionLabel.topAnchor --> view.safeAreaLayoutGuide.topAnchor + Const.View.m16
        topSectionLabel.leadingAnchor --> view.leadingAnchor
        topSectionLabel.trailingAnchor --> view.trailingAnchor
        topSectionLabel.textAlignment = .center
        topSectionLabel.numberOfLines = 0
        topSectionLabel.lineBreakMode = .byWordWrapping
    }
    
    private func configureSelectedButton() {
        selectedButtonIcon.autoresizingOff()
        selectedButtonTitle.autoresizingOff()
        buttonSectionView.autoresizingOff()
        buttonSectionView.addSubview(selectedButtonIcon)
        buttonSectionView.addSubview(selectedButtonTitle)
        let icon = Const.Assets.InitPhoneNumber.chevronRight
        
        selectedButtonIcon.setImage(icon, for: .normal)
        selectedButtonIcon.imageView?.contentMode = .scaleAspectFit
        selectedButtonIcon.trailingAnchor --> buttonSectionView.trailingAnchor + -Const.View.m16
        selectedButtonIcon.topAnchor --> buttonSectionView.topAnchor
        selectedButtonIcon.bottomAnchor --> buttonSectionView.bottomAnchor
       
        selectedButtonTitle.topAnchor --> buttonSectionView.topAnchor
        selectedButtonTitle.bottomAnchor --> buttonSectionView.bottomAnchor
        selectedButtonTitle.leadingAnchor --> buttonSectionView.leadingAnchor + Const.View.m16
        selectedButtonTitle.setTitle(presenter.myCountryName, for: .normal)
        selectedButtonTitle.setTitleColor(Const.Color.label, for: .normal)
        view.addSubview(buttonSectionView)
        buttonSectionView.topAnchor --> topSectionLabel.bottomAnchor + Const.View.m16
        buttonSectionView.leadingAnchor --> view.leadingAnchor
        buttonSectionView.trailingAnchor --> view.trailingAnchor
        
        buttonSectionView.addDividerLine(to: [.bottom, .top])
    }
    
    private func configurePhoneNumberSectionView() {
        phoneNumberSectionView.autoresizingOff()
        configurePhoneNumberSectionCountryCode()
        configrePhoneNumberSectionInputField()
        view.addSubview(phoneNumberSectionView)
        
        phoneNumberSectionView.topAnchor --> buttonSectionView.bottomAnchor
        phoneNumberSectionView.leadingAnchor --> view.leadingAnchor
        phoneNumberSectionView.trailingAnchor --> view.trailingAnchor
        phoneNumberSectionView.addDividerLine(to: [.bottom])
        
    }
    
    private func configurePhoneNumberSectionCountryCode() {
        phoneNumberSectionCountryCodeLabel.autoresizingOff()
        phoneNumberSectionCountryCodeLabel.widthAnchor --> 60
        phoneNumberSectionView.addSubview(phoneNumberSectionCountryCodeLabel)
        phoneNumberSectionCountryCodeLabel.leadingAnchor --> phoneNumberSectionView.leadingAnchor + Const.View.m16
        phoneNumberSectionCountryCodeLabel.topAnchor --> phoneNumberSectionView.topAnchor
        phoneNumberSectionCountryCodeLabel.bottomAnchor --> phoneNumberSectionView.bottomAnchor
        phoneNumberSectionCountryCodeLabel.addDividerLine(to: [.right])
        phoneNumberSectionCountryCodeLabel.textAlignment = .center
    }
    
    private func configrePhoneNumberSectionInputField() {
        phoneNumberSectionInputField.autoresizingOff()
        phoneNumberSectionInputField.placeholder = presenter.phoneNumberPlaceholderText
        phoneNumberSectionView.addSubview(phoneNumberSectionInputField)
        phoneNumberSectionInputField.leadingAnchor --> phoneNumberSectionCountryCodeLabel.trailingAnchor + Const.View.m8
        phoneNumberSectionInputField.bottomAnchor --> phoneNumberSectionView.bottomAnchor + -Const.View.m8
        phoneNumberSectionInputField.trailingAnchor --> phoneNumberSectionView.trailingAnchor
        phoneNumberSectionInputField.topAnchor --> phoneNumberSectionView.topAnchor + Const.View.m8
    }
}
