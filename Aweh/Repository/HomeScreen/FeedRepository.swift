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
class FeedRepository {
    let service = AwehServiceInstance.service
    
    func getPosts(result: @escaping (Result<[Post], Error>) -> Void) {
        service.$getPosts { response in
            switch response {
            case .success(let postsResponse):
                result(.success(postsResponse.body))
            case .failure(let error):
                result(.failure(error))
            }
        }
    }
}

class StatusRepository {
    
}

class StoryRepository {
    
}
