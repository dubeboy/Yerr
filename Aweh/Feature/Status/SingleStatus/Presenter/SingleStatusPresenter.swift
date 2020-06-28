//
//  StatusPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/23.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol SingleStatusPresenter  {
   
}

class SingleStatusPresenterImplementation: SingleStatusPresenter {
    let viewModel: StatusViewModel
    
    init(viewModel: StatusViewModel) {
        self.viewModel = viewModel
    }

}
