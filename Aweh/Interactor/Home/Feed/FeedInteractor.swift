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
    
}
