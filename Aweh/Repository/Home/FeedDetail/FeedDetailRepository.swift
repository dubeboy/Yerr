//
//  FeedDetailRepository.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/09.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

struct FeedDetailRepository: RepositoryInjectable {
    
    @SingletonServiceInstance
    var service: AwehService
    
    
    func getComments(statusId: String, result: @escaping (Result<StatusResponseEntity<[Comment]>, Error>) -> Void) {
        service.$getComments(["status_id": statusId]) { response in
            switch response {
                case .success(let statusReponse):
                    result(.success(statusReponse.body))
                case .failure(let error):
                    result(.failure(error))
            }
        }
    }
}
