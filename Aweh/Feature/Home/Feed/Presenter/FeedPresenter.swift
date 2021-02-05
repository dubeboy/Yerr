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
    var isFetching: Bool { get set  }
    var hasReachedEnd: Bool { get set  }
    var feedCellPresenter: FeedCellPresenter { get }

    func getStatuses(page: Int, interestName: String?, completion: @escaping (Int?, String?) -> Void)
    func getStatus(at index: IndexPath) -> StatusViewModel
    func index(for item: StatusViewModel) -> Int
    
    func addNewStatus(_ statusViewModel: StatusViewModel)
    
    func didTapLikeButton(at indexPath: IndexPath, cell: FeedCollectionViewCell)
    func didTapDownVoteButton(at indexPath: IndexPath)
    func didTapUpVoteButton(at indexPath: IndexPath)
    func didCompleteSetup(complete: Completion<()>, notComplete: Completion<()>)
    func setupComplete(completion: Completion<()>)
    func refresh()
    
    func nextPage() -> Int
}

struct FeedViewModel {
    var statuses: [StatusViewModel] = []
    var page: Int = 0
    var hasReachedEnd = false
    var isFetching = false
}

class FeedPresenterImplemantation: FeedPresenter {
  
    let feedCellPresenter: FeedCellPresenter = FeedCellPresenter()
    let feedIntercator: StatusesUseCase = FeedInteractor()
    var interest: InterestViewModel? = nil
    
    private var viewModel: FeedViewModel = FeedViewModel()
    
    private var statuses: [StatusViewModel] {
        get {
            viewModel.statuses
        }
        set {
            viewModel.statuses = newValue
        }
    }
    
    var isFetching: Bool {
        get {
            viewModel.isFetching
        }
        set {
            viewModel.isFetching = newValue
        }
    }
    
    @UserDefaultsBacked(key: .didFinishLaunching, defaultValue: false)
    var didCompleteSetup: Bool

    func index(for item: StatusViewModel) -> Int {
        statuses.firstIndex {
            item == $0
        } ?? 0
    }
    
    func getStatus(at index: IndexPath) -> StatusViewModel {
        statuses[index.item]
    }
    
    var statusCount: Int {
        statuses.count
    }
    
    var hasReachedEnd: Bool { // should probably be accompanies by a refreshed state
        get {
            viewModel.hasReachedEnd
        }
        set {
            viewModel.hasReachedEnd = newValue
        }
    }
    
    func getStatuses(page: Int, interestName: String?, completion: @escaping (Int?, String?) -> Void) {
        isFetching = true
        if interestName == nil {
            getFeedStatuses(page: page, completion: completion)
        } else {
            getFeedStatusesForInterest(name: interestName!, completion: completion)
        }
    }
    
    private func getFeedStatuses(page: Int, completion: @escaping (Int?, String?) -> ()) {
        feedIntercator.getStatuses(page: page) { [weak self] result in
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
            self.statuses.append(contentsOf: result.map(StatusViewModel.transform(from:)))
            isFetching = false
            completion(self.statuses.count, nil)
        case .failure(let error):
            isFetching = false
            completion(nil, error.localizedDescription)
            
        }
    }

    private func statusResponse(result: StatusViewModel, completion: @escaping (Int?, String?) -> Void) {

    }
    
    func addNewStatus(_ statusViewModel: StatusViewModel) {
        statuses.insert(statusViewModel, at: 0)
    }
    
    func didTapLikeButton(at indexPath: IndexPath, cell: FeedCollectionViewCell) {
        let item = statuses[indexPath.item]
        increamentLikes(itemIndex: indexPath.item, cell: cell)
        feedIntercator.postLike(voteEntity: createPostVoteEntity(item: item)) { [weak self] result in
            switch result {
                case .success(let result):
                    if result {
                        Logger.i(result)
                    } else {
                        self?.decrementLikes(itemIndex: indexPath.item, cell: cell)
                    }
                case .failure(let error):
                    Logger.i(error.localizedDescription)
                    self?.decrementLikes(itemIndex: indexPath.item, cell: cell)
            }
        }
    }
    
    // clear statuses
    // reset hasReachedEnd
    func refresh() {
        
    }
    
    private func increamentLikes(itemIndex: Int, cell: FeedCollectionViewCell) {
        var item = statuses[itemIndex]
        item.likes += 1
        statuses[itemIndex] = item
        feedCellPresenter.setLikes(cell: cell, likes: item.likes)
    }
    
    private func decrementLikes(itemIndex: Int, cell: FeedCollectionViewCell) {
        var item = statuses[itemIndex]
        item.likes -= 1
        statuses[itemIndex] = item
        feedCellPresenter.setLikes(cell: cell, likes: item.likes)
    }
   
    func didTapDownVoteButton(at indexPath: IndexPath) {
        let item = statuses[indexPath.item]
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
        let item = statuses[indexPath.item]
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
    
    func nextPage() -> Int {
        var page = viewModel.page
        page += 1
        viewModel.page = page
        return page
    }
    
    private func removeVote(at indexPath: IndexPath) {
        let item = statuses[indexPath.item]
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
