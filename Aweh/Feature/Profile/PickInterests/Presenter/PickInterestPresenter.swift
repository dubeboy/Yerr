//
//  PickInterestPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/05.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol PickInterestPresenter {
    var pickInterestCellPresenter: PickInterestCellPresenter { get }
    
    func getInterest(at indexPath: IndexPath) -> InterestViewModel
    
    func interestsCount() -> Int
}

class PickInterestPresenterImplementation: PickInterestPresenter {
  
    var pickInterestCellPresenter: PickInterestCellPresenter
    let viewModel: [InterestViewModel]
    
    init(viewModel: [InterestViewModel]) {
        self.viewModel = viewModel
        pickInterestCellPresenter = PickInterestCellPresenter()
    }
    
    func getInterest(at indexPath: IndexPath) -> InterestViewModel {
        viewModel[indexPath.row]
    }
    
    func interestsCount() -> Int {
        viewModel.count
    }
}
