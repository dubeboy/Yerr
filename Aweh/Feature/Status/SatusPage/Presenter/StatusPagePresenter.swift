//
//  StatusesPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/23.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol StatusPagePresenter {
    var title: String { get }
   
    func getUserStatus(
        page: Int,
        completion: @escaping (UserViewModel) -> Void
    )
    
    func getFirstPageCount() -> Int
    
    func appendViewControllers(_ singlePageViewControllers: [SingleStatusViewController]) // TODO: Not correct
    
}

class StatusPagePresenterImplemantation: StatusPagePresenter {
    var title: String { viewModel.interestName }
    let viewModel: InterestViewModel
    
    var currentPages: [SingleStatusViewController] = []
    
    init(with viewModel: InterestViewModel) {
        self.viewModel = viewModel
    }
    
    func getUserStatus(
        page: Int,
        completion: @escaping (UserViewModel) -> Void
    ) {
        // TODO: - here we should perform a request here based on interest ID
        let userViewModel = viewModel.users[page]
        completion(userViewModel)
    }
    
    func getFirstPageCount() -> Int {
        return viewModel.users.count
    }
    
    func appendViewControllers(_ singlePageViewControllers: [SingleStatusViewController]) {
        currentPages = singlePageViewControllers
    }
}
