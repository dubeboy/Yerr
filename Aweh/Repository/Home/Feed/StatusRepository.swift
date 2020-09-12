//
//  HomeScreenRepository.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/04.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

// We do data here we inject the Remote
// We also inject the local data
struct StatusRepository: RepositoryInjectable {

    @SingletonServiceInstance
    var service: AwehService
    
    func getStatuses(result: @escaping (Result<StatusResponseEntity<[Status]>, Error>) -> Void) {
        service.$getStatuses { response in
            switch response {
            case .success(let statusReponse):
                result(.success(statusReponse.body))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
}

