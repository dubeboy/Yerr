//
//  HomeScreenRepository.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/04.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Merchant

// We do data here we inject the Remote
// We also inject the local data if needed
// should be interfaced out!!!
struct StatusRepository: NewInstanceInjectable {

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

    func postStatus(status: Status, result: @escaping (Result<StatusResponseEntity<Status>, Error>) -> Void) {
        service.$postStatus(body: status) { response in
            switch response {
                case .success(let statusReponse):
                    result(.success(statusReponse.body))
                case .failure(let error):
                    result(.failure(error))
            }
        }
    }
    
    func postLike(voteEntity: VoteEntity, result: @escaping (Result<StatusResponseEntity<Bool>, Error>) -> Void) {
        service.$postLike(body: voteEntity) { response in
            switch response {
                case .success(let statusReponse):
                    result(.success(statusReponse.body))
                case .failure(let error):
                    result(.failure(error))
            }
        }
    }
    
    func postVote(voteEntity: VoteEntity, result: @escaping (Result<StatusResponseEntity<Bool>, Error>) -> Void) {
        service.$postVote(body: voteEntity) { response in
            switch response {
                case .success(let statusReponse):
                    result(.success(statusReponse.body))
                case .failure(let error):
                    result(.failure(error))
            }
        }
    }
    
    func postRemoveVote(voteEntity: VoteEntity, result: @escaping (Result<StatusResponseEntity<Bool>, Error>) -> Void) {
        service.$postRemoveVote(body: voteEntity) { response in
            switch response {
                case .success(let statusReponse):
                    result(.success(statusReponse.body))
                case .failure(let error):
                    result(.failure(error))
            }
        }
    }
    
    func postStatusMedia(statusId: String,
                         media: [MultipartBody],
                         result: @escaping (Result<StatusResponseEntity<Status>, Error>) -> Void) {
        
        service.$postStatusMedia(["status_id": statusId], body: media) { response in
            switch response {
                case .success(let statusReponse):
                    result(.success(statusReponse.body))
                case .failure(let error):
                    result(.failure(error))
            }
        }
    }
}

