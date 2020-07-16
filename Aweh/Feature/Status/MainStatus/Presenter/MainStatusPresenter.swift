//
//  MainStatusPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/13.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol MainStatusPresenter {
    func viewControllersPresenters(at index: Int) -> MainStatusViewModelSelection
}

class MainStatusPresenterImplementation: MainStatusPresenter {
    let viewModel: MainStatusViewModel
    
    var viewsInMemory = [Int: Bool]()
    
    init(_ viewModel: MainStatusViewModel = MainStatusPresenterImplementation.mockData()) {
        self.viewModel = viewModel
    }
    
    func viewControllersPresenters(at index: Int) -> MainStatusViewModelSelection {
        if index == 0 {
            return .interests(viewModel.interests)
        } else if index == 1 {
            return .replies(viewModel.replies)
        } else {
            preconditionFailure("There should only be two indices")
        }
    }
    
    private static func mockData() -> MainStatusViewModel {
        let mockInterest = InterestsPresenterImplemantation.stub()[0]
        let replies = RepliesViewModel()
        return MainStatusViewModel(interests: mockInterest, replies: replies)
    }
}
