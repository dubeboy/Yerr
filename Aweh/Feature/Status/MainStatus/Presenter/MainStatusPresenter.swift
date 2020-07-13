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
    func setIsInMemory(at index: Int)
    func isViewInMemory(at index: Int) -> Bool?
}

class MainStatusPresenterImplementation: MainStatusPresenter {
    let viewModel: MainStatusViewModel
    
    var viewsInMemory = [Int: Bool]()
    
    init(_ viewModel: MainStatusViewModel) {
        self.viewModel = viewModel
    }
    
    func viewControllersPresenters() -> MainStatusViewModel {
        viewModel
    }
    
    func setIsInMemory(at index: Int){
        viewsInMemory[index] = true
    }
    
    func isViewInMemory(at index: Int) -> Bool? {
        viewsInMemory[index]
    }
}
