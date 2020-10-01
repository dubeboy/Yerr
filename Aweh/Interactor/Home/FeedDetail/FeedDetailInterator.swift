//
//  FeedDetailInterator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/09.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol CommentsUseCase {
    func getComments(statusId: String, result: @escaping (Result<[Comment], Error>) -> Void)
}

struct FeedDetailInteractor: CommentsUseCase {
    
    @InjectNewInstance
    private var feedDetailRepository: FeedDetailRepository
    
    func getComments(statusId: String, result: @escaping (Result<[Comment], Error>) -> Void) {
        feedDetailRepository.getComments(statusId: statusId) { response in
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
    
    func postComments(statusId: String, comment: Comment, result: @escaping (Result<String, Error>) -> Void) {
        feedDetailRepository.postPostComment(statusId: statusId, comment: comment) { response in
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
