//
//  FeedPresenterImplemantation.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/03.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol FeedPresenter {
    var statusCount: Int { get }
    var feedCellPresenter: FeedCellPresenter { get }

    func getStatuses(completion: @escaping (Int?, String?) -> Void)
    func getStatus(at index: IndexPath) -> StatusViewModel
    func index(for item: StatusViewModel) -> Int
}

class FeedPresenterImplemantation: FeedPresenter {
    
    let feedCellPresenter: FeedCellPresenter = FeedCellPresenter()
    let feedIntercator: StatusesUseCase = FeedInteractor()
    
    var viewModel: [StatusViewModel] = []

    func index(for item: StatusViewModel) -> Int {
        viewModel.firstIndex {
            item == $0
        } ?? 0
    }
    
    func getStatus(at index: IndexPath) -> StatusViewModel {
        viewModel[index.item]
    }
    
    var statusCount: Int {
        viewModel.count
    }
    
    func getStatuses(completion: @escaping (Int?, String?) -> Void) {
        feedIntercator.getStatuses { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let result):
                self.viewModel = result.map(StatusViewModel.transform(from:))
                completion(self.viewModel.count, nil)
            case .failure(let error):
                completion(nil, error.localizedDescription)
            }
        }
    }
}
