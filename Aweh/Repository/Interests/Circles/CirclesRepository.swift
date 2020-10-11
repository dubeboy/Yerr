//
//  CirclesRepository.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/10.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

struct CirclesRepository: NewInstanceInjectable {
    
    @SingletonServiceInstance
    private var service: AwehService
    
    func getAllCircles(result: @escaping RepositoryResponseClousure<[Interest]>) {
        service.$getAllCircles { response in
            switch response {
                case .success(let circlesResponse):
                    result(.success(circlesResponse.body))
                case .failure(let error):
                    result(.failure(error))
            }
        }
    }
    
    func postJoinCircle(userCircleRequestObject: UserCircleRequestObject,
                     result: @escaping RepositoryResponseClousure<Bool>) {
        service.$postJoinCircle(body: userCircleRequestObject) { response in
            switch response {
                case .success(let circlesResponse):
                    result(.success(circlesResponse.body))
                case .failure(let error):
                    result(.failure(error))
            }
        }
    }
    
    func getMyCircles(userId: String, result: @escaping RepositoryResponseClousure<[Interest]>) {
        service.$getMyCircles(query: ["user_id": userId]) { response in
            switch response {
                case .success(let circlesResponse):
                    result(.success(circlesResponse.body))
                case .failure(let error):
                    result(.failure(error))
            }
        }
    }
}
