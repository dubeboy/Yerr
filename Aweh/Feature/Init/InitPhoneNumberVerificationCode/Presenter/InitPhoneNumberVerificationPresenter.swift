//
//  InitPhoneNumberVerificationPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/25.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol InitPhoneNumberVerificationPresenter {
    var headerText: String { get }
}

class InitPhoneNumberVerificationPresenterImplementation: InitPhoneNumberVerificationPresenter {
    var headerText: String = AppStrings.OTP.headerText
    
    
}
