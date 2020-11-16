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
   
    func getUserStatus(page: Int, completion: @escaping (UserViewModel) -> Void)
    func getFirstPageCount() -> Int
    func setViewControllers(_ singlePageViewControllers: [SingleStatusViewController]) // TODO: - Not correct
    func indexOf(viewController: SingleStatusViewController) -> Int?
    func viewController(at index: Int) -> SingleStatusViewController?
    func currentPagesCount() -> Int
    func setViewModel(viewModel: StatusPageViewModel)
}

class StatusPagePresenterImplemantation: StatusPagePresenter {
   
    var title: String = "jfdfjdhfgdhjgfd"
    
    var viewModel: StatusPageViewModel?
    
    var currentPages: [SingleStatusViewController] = []
    
    func getUserStatus(
        page: Int,
        completion: @escaping (UserViewModel) -> Void
    ) {
        // TODO: - here we should perform a request here based on interest ID
//        let userViewModel = viewModel.users[page]
//        completion(userViewModel)
    }
    
    func getFirstPageCount() -> Int {
//        viewModel.users.count
        return 0
    }
    
    func setViewControllers(_ singlePageViewControllers: [SingleStatusViewController]) {
        currentPages = singlePageViewControllers
    }
    
    func indexOf(viewController: SingleStatusViewController) -> Int? {
        currentPages.firstIndex(of: viewController)
    }
    
    func viewController(at index: Int) -> SingleStatusViewController? {
        if index < currentPages.count {
             return currentPages[index]
        }
        return nil 
    }
    
    func currentPagesCount() -> Int {
        currentPages.count
    }
    
    func setViewModel(viewModel: StatusPageViewModel) {
        self.viewModel = viewModel
        // TODO: trigger the view to load the content
    }
}
