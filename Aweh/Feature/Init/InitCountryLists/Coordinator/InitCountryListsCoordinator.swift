//
//  InitCountryListsCoordinator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/31.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

protocol InitCountryListsCoordinator: AnyObject {
    func startInitCountryListsViewController(didSelectCountry: @escaping (CountryViewModel) -> Void)
}

extension InitScreensCoordinator: InitCountryListsCoordinator {
    func startInitCountryListsViewController(didSelectCountry: @escaping (CountryViewModel) -> Void) {
        let viewController = InitCountryListsViewController()
        viewController.coordinator = self
        viewController.didSelect = didSelectCountry
        viewController.presenter = InitCountryListsPresenterImplementation()
        let presentationNav = UINavigationController(rootViewController: viewController)
        navigationController.present(presentationNav, animated: true, completion: nil)
    }
}
