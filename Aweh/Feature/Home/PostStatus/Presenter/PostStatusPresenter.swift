//
//  PostStatusPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/07.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol PostStatusPresenter {
    var placeHolderText: String { get }
    var numberOfAllowedChars: String { get }

    func postStatus(status: String?,
                    completion: @escaping Completion<StatusViewModel>,
                    error: @escaping Completion<String>)
    
}

class PostStatusPresenterImplementation: PostStatusPresenter {
   
    let feedInteractor = FeedInteractor()
    var placeHolderText: String = "Aweh!!! What's poppin'?"
    var numberOfAllowedChars: String = "240"
    
    func postStatus(status: String?,
                    completion: @escaping Completion<StatusViewModel>,
                    error: @escaping Completion<String>) {
        
        guard let status = status, !status.isEmpty else { return }
        let statusEntity = Status(id: nil,
                                  body: status,
                                  user: .dummyUser,
                                  comments: [],
                                  location: .dummyLocation,
                                  media: [],
                                  likes: 0,
                                  votes: 0,
                                  createdAt: Date())
        
        feedInteractor.postStatuses(status: statusEntity) { result in
            switch result {
                case .success(let success):
                    completion(.transform(from: success))
                case .failure(let e):
                    error(e.localizedDescription)
            }
        }
    }
    
    deinit {
        print("killed❌")
    }
    
}


