//
//  InitPhoneNumberVerficationCodeCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/25.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol InitPhoneNumberVerficationCodeCoordinator: AnyObject {
    func createOTPViewController() -> InitPhoneNumberVerificationViewController
    func startOTPViewController()
}

extension InitScreensCoordinator: InitPhoneNumberVerficationCodeCoordinator  {
    func createOTPViewController() -> InitPhoneNumberVerificationViewController {
        navigationController.delegate = self
        let mainViewController = InitPhoneNumberVerificationViewController()
        mainViewController.coordinator = self
        mainViewController.presenter = InitPhoneNumberVerificationPresenterImplementation()
        mainViewController.hidesBottomBarWhenPushed = true
        return mainViewController
    }
    
    func startOTPViewController() {
        let viewController = createOTPViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
    
    
}
