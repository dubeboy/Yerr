//
//  HomeScreenInteractor.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/04.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol StatusesUseCase {
    func getStatuses(result: @escaping (Result<[Status], Error>) -> Void)
    func postStatuses(status: Status, result: @escaping (Result<Status, Error>) -> Void)
    func postLike(voteEntity: VoteEntity, result: @escaping (Result<Bool, Error>) -> Void)
    func postVote(voteEntity: VoteEntity, result: @escaping (Result<Bool, Error>) -> Void)
    func postRemoveVote(voteEntity: VoteEntity, result: @escaping (Result<Bool, Error>) -> Void)
}

struct FeedInteractor: StatusesUseCase {


    @InjectRepository
    private var statusRepository: StatusRepository
    
    func getStatuses(result: @escaping (Result<[Status], Error>) -> Void) {
        statusRepository.getStatuses { response in
            switch response {
            case .success(let statusResponse):
                guard let entity = statusResponse.entity else {
                    return result(.failure(FeedError.nilStatusesArray))
                }
                result(.success(entity))
            case .failure(let error):
                Logger.log(error)
                return result(.failure(FeedError.noInternetConnection))
            }
        }
    }
    
    // part of feed because this view will be modally presented
    func postStatuses(status: Status, result: @escaping (Result<Status, Error>) -> Void) {
        statusRepository.postStatus(status: status) { response in
            switch response {
                case .success(let statusResponse):
                    guard let entity = statusResponse.entity else {
                        return result(.failure(FeedError.nilStatusesArray))
                    }
                    result(.success(entity))
                case .failure(let error):
                    Logger.log(error)
                    return result(.failure(FeedError.noInternetConnection))
            }
        }
    }
    
    func postLike(voteEntity: VoteEntity, result: @escaping (Result<Bool, Error>) -> Void) {
        statusRepository.postLike(voteEntity: voteEntity) { response in
            switch response {
                case .success(let statusResponse):
                    guard let entity = statusResponse.entity else {
                        return result(.failure(FeedError.nilStatusesArray))
                    }
                    result(.success(entity))
                case .failure(let error):
                    Logger.log(error)
                    return result(.failure(FeedError.noInternetConnection))
            }
        }
    }
    
    func postVote(voteEntity: VoteEntity, result: @escaping (Result<Bool, Error>) -> Void) {
        statusRepository.postVote(voteEntity: voteEntity) { response in
            switch response {
                case .success(let statusResponse):
                    guard let entity = statusResponse.entity else {
                        return result(.failure(FeedError.nilStatusesArray))
                    }
                    result(.success(entity))
                case .failure(let error):
                    Logger.log(error)
                    return result(.failure(FeedError.noInternetConnection))
            }
        }
    }
    
    func postRemoveVote(voteEntity: VoteEntity, result: @escaping (Result<Bool, Error>) -> Void) {
        statusRepository.postRemoveVote(voteEntity: voteEntity) { response in
            switch response {
                case .success(let statusResponse):
                    guard let entity = statusResponse.entity else {
                        return result(.failure(FeedError.nilStatusesArray))
                    }
                    result(.success(entity))
                case .failure(let error):
                    Logger.log(error)
                    return result(.failure(FeedError.noInternetConnection))
            }
        }
    }
    
}
