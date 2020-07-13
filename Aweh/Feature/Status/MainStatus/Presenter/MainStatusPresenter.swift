//
//  MainStatusPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/13.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation



protocol MainStatusPresenter {
    func viewControllersPresenters() -> MainStatusViewModel
}

class MainStatusPresenterImplementation: MainStatusPresenter {
    let viewModel: MainStatusViewModel
    
    init(_ viewModel: MainStatusViewModel) {
        self.viewModel = viewModel
    }
    
    func viewControllersPresenters() -> MainStatusViewModel {
        viewModel
    }
}
