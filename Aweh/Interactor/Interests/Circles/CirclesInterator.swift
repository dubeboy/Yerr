//
//  StatusInterator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/10.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol CirclesUseCase {
    func getAllCircles(result: @escaping InteractorResponseClousure<[Interest]>)
    func joinCircle(userCircleRequestObject: UserCircleRequestObject, result: @escaping InteractorResponseClousure<Bool>)
    func getMyCircles(userId: String, result: @escaping InteractorResponseClousure<[Interest]>)
}

class CirclesInteractor: CirclesUseCase {
    
    @InjectNewInstance
    private var circlesRepository: CirclesRepository
    
    func getAllCircles(result: @escaping InteractorResponseClousure<[Interest]>) {
        circlesRepository.getAllCircles { response in
            switch response {
                case .success(let circlesResponse):
                    guard let entity = circlesResponse.entity else {
                        return result(.failure(FeedError.nilStatusesArray))
                    }
                    result(.success(entity))
                case .failure(let error):
                    Logger.log(error)
                    return result(.failure(FeedError.noInternetConnection))
            }
        }
    }
    
    func joinCircle(userCircleRequestObject: UserCircleRequestObject, result: @escaping InteractorResponseClousure<Bool>) {
        circlesRepository.postJoinCircle(userCircleRequestObject: userCircleRequestObject) { response in
            switch response {
                case .success(let circlesResponse):
                    guard let entity = circlesResponse.entity else {
                        return result(.failure(FeedError.nilStatusesArray))
                    }
                    result(.success(entity))
                case .failure(let error):
                    Logger.log(error)
                    return result(.failure(FeedError.noInternetConnection))
            }
        }
    }
    
    func getMyCircles(userId: String, result: @escaping InteractorResponseClousure<[Interest]>) {
        circlesRepository.getMyCircles(userId: userId) { response in
            switch response {
                case .success(let circlesResponse):
                    guard let entity = circlesResponse.entity else {
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
