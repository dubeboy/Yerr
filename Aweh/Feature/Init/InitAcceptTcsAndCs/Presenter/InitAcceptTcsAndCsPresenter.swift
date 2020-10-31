//
//  InitAcceptTcsAndCsPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/22.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol InitAcceptTcsAndCsPresenter {
    var acceptTsText: String { get }
    var linkToTsCs: String { get }
    var acceptTsAndCButtonTitle: String { get }
    var welcomeTitle: String { get }
    var title: String { get }
}

class InitAcceptTcsAndCsPresenterImplemetation: InitAcceptTcsAndCsPresenter {
    var title: String =  AppStrings.AcceptTsAndCs.title
    
    let acceptTsText = AppStrings.AcceptTsAndCs.acceptTsAndC
    let acceptTsAndCButtonTitle = AppStrings.AcceptTsAndCs.acceptTsAndCsButtonTitle
    let linkToTsCs = AppStrings.AcceptTsAndCs.linkToTsCs
    let welcomeTitle = AppStrings.AcceptTsAndCs.title
    
}
