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
    var resendButtonTitle: String { get }
    var continueButtonTitle: String { get }
}

class InitPhoneNumberVerificationPresenterImplementation: InitPhoneNumberVerificationPresenter {
    var resendButtonTitle: String = AppStrings.OTP.resend
    
    var continueButtonTitle: String = AppStrings.OTP.continueTitle
    
    var headerText: String = AppStrings.OTP.headerText
    
    
}
