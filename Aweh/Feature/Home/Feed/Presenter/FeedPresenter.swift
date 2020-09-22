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
    
    func addNewStatus(_ statusViewModel: StatusViewModel)
    
    func didTapLikeButton(at indexPath: IndexPath)
    func didTapDownVoteButton(at indexPath: IndexPath)
    func didTapUpVoteButton(at indexPath: IndexPath)
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
    
    func addNewStatus(_ statusViewModel: StatusViewModel) {
        viewModel.insert(statusViewModel, at: 0)
    }
    
    func didTapLikeButton(at indexPath: IndexPath) {
        let item = viewModel[indexPath.item]
        feedIntercator.postLike(voteEntity: createPostVoteEntity(item: item)) { result in
            switch result {
                case .success(let result):
                    Logger.i(result)
                case .failure(let error):
                    Logger.i(error.localizedDescription)
            }
        }
    }
    
   
    func didTapDownVoteButton(at indexPath: IndexPath) {
        let item = viewModel[indexPath.item]
        feedIntercator.postVote(voteEntity: createPostVoteEntity(item: item)) { result in
            switch result {
                case .success(let result):
                    Logger.i(result)
                case .failure(let error):
                    Logger.i(error.localizedDescription)
            }
        }
    }
    
    func didTapUpVoteButton(at indexPath: IndexPath) {
        let item = viewModel[indexPath.item]
        feedIntercator.postVote(voteEntity: createPostVoteEntity(item: item)) { result in
            switch result {
                case .success(let result):
                    Logger.i(result)
                    
                case .failure(let error):
                    Logger.i(error.localizedDescription)
            }
        }
    }
    
    private func removeVote() {
        
    }
    
    private func createPostVoteEntity(item: StatusViewModel) -> VoteEntity {
        // TODO get this from the user defaults
        let userEntityID = UserEntityID(userId: "1000", entityId: item.id)
        return VoteEntity(id: userEntityID)
    }
    
    
}
