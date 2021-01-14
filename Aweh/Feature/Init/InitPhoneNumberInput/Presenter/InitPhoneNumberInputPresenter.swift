//
//  InitPhoneNumberInputPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol InitPhoneNumberInputPresenter {
    var confirmPhoneNumberText: String { get }
    var phoneNumberPlaceholderText: String { get }
    var title: String { get }
    var myCountryName: String { get }
    var doneBarButtonItem: String { get }
}

class InitPhoneNumberInputPresenterImplementation: InitPhoneNumberInputPresenter {
    var doneBarButtonItem: String = AppStrings.InitPhoneNumberInput.doneBarButton
    
    var myCountryName: String =  "South Africa"
    
    var phoneNumberPlaceholderText: String = AppStrings.InitPhoneNumberInput.phoneNumberPlaceholderText
    let title: String = AppStrings.InitPhoneNumberInput.title
    let confirmPhoneNumberText = AppStrings.InitPhoneNumberInput.confirmPhoneNumberText
    
}
