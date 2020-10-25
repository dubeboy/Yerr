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
}

class InitPhoneNumberInputPresenterImplementation: InitPhoneNumberInputPresenter {
    var phoneNumberPlaceholderText: String = AppStrings.InitPhoneNumberInput.phoneNumberPlaceholderText
    
    let confirmPhoneNumberText = AppStrings.InitPhoneNumberInput.confirmPhoneNumberText
}
