//
//  StatusPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/23.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol SingleStatusPresenter  {
    func getStatusesFor(
        interest viewModel: InterestViewModel,
        completion: @escaping ([SingleStatusViewModel]) -> Void
    )
}

class SingleStatusPresenterImplementation: SingleStatusPresenter {
    let viewModel: SingleStatusViewModel
    
    init(viewModel: SingleStatusViewModel) {
        self.viewModel = viewModel
    }
    
    func getStatusesFor(interest viewModel: InterestViewModel, completion: @escaping ([SingleStatusViewModel]) -> Void) {
        
    }
}
