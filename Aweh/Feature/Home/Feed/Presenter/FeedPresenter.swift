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

    func getStatuses(interestName: String?, completion: @escaping (Int?, String?) -> Void)
    func getStatus(at index: IndexPath) -> StatusViewModel
    func index(for item: StatusViewModel) -> Int
    
    func addNewStatus(_ statusViewModel: StatusViewModel)
    
    func didTapLikeButton(at indexPath: IndexPath)
    func didTapDownVoteButton(at indexPath: IndexPath)
    func didTapUpVoteButton(at indexPath: IndexPath)
    func didCompleteSetup(complete: Completion<()>, notComplete: Completion<()>)
    func setupComplete(completion: Completion<()>)
}

class FeedPresenterImplemantation: FeedPresenter {
  
    let feedCellPresenter: FeedCellPresenter = FeedCellPresenter()
    let feedIntercator: StatusesUseCase = FeedInteractor()
    var interest: InterestViewModel? = nil
    
    var viewModel: [StatusViewModel] = []
    
    @UserDefaultsBacked(key: .didFinishLaunching, defaultValue: false)
    var didCompleteSetup: Bool

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
    
    func getStatuses(interestName: String?, completion: @escaping (Int?, String?) -> Void) {
        if interestName == nil {
            getFeedStatuses(completion: completion)
        } else {
            guard let interestName = interestName else {
                Logger.log(AppStrings.Error.interestNameNil)
                return
            }
            getFeedStatusesForInterest(name: interestName, completion: completion)
        }
    }
    
    private func getFeedStatuses(completion: @escaping (Int?, String?) -> ()) {
        feedIntercator.getStatuses { [weak self] result in
            guard let self = self else { return }
            self.handleStatusResponse(result: result, completion: completion)
        }
    }

    private func getFeedStatusesForInterest(name: String, completion: @escaping (Int?, String?) -> ()) {
        feedIntercator.getStatuses(interestName: name) { [weak self] result in
            guard let self = self else { return }
            self.handleStatusResponse(result: result, completion: completion)
        }
    }


    private func handleStatusResponse(result: Result<[Status], Error>,
                                      completion: @escaping (Int?, String?) -> Void) {
        switch result {
        case .success(let result):
            self.viewModel = result.map(StatusViewModel.transform(from:))
            completion(self.viewModel.count, nil)
        case .failure(let error):
            completion(nil, error.localizedDescription)
        }
    }

    private func statusResponse(result: StatusViewModel, completion: @escaping (Int?, String?) -> Void) {

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
        var postVote = createPostVoteEntity(item: item)
        postVote.direction = false
        feedIntercator.postVote(voteEntity: postVote) { result in
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
        var postVote = createPostVoteEntity(item: item)
        postVote.direction = true
        feedIntercator.postVote(voteEntity: postVote) { result in
            switch result {
                case .success(let result):
                    Logger.i(result)
                    
                case .failure(let error):
                    Logger.i(error.localizedDescription)
            }
        }
    }
    
    func didCompleteSetup(complete: Completion<()>, notComplete: Completion<()>) {
        switch didCompleteSetup {
            case true:
                complete(())
            case false:
                notComplete(())
        }
    }
    
    func setupComplete(completion: Completion<()>) {
        didCompleteSetup = true
        completion(())
    }
    
    private func removeVote(at indexPath: IndexPath) {
        let item = viewModel[indexPath.item]
        let postVote = createPostVoteEntity(item: item)
        feedIntercator.postRemoveVote(voteEntity: postVote) { result in
            switch result {
                case .success(let result):
                    Logger.i(result)
                case .failure(let error):
                    Logger.i(error.localizedDescription)
            }
        }
    }
    
    private func createPostVoteEntity(item: StatusViewModel) -> VoteEntity {
        // TODO get this from the user defaults
        let userEntityID = UserEntityID(userId: "1000", entityId: item.id)
        return VoteEntity(id: userEntityID)
    }
    
    
}
