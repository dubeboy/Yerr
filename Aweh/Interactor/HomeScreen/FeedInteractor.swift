//
//  HomeScreenInteractor.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/04.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol PostUseCase {
    func getPosts(result: @escaping (Result<[Post], Error>) -> Void)
}

protocol StoriesUseCase {
    
}

protocol PostStatusUseCase {
    
}

class FeedInteractor: PostUseCase {
    
    let repository = FeedRepository()
    
    func getPosts(result: @escaping (Result<[Post], Error>) -> Void) {
        repository.getPosts(result: result)
    }
}

extension FeedInteractor: StoriesUseCase {
    
}

extension FeedInteractor: PostStatusUseCase {
    
}

