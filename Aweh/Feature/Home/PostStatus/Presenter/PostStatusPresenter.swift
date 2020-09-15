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
    
    func postStatus(status: String,
                    completion: @escaping Completion<StatusViewModel>,
                    error: @escaping Completion<String>)
    
}

class PostStatusPresenterImplementation: PostStatusPresenter {
   
    
    var placeHolderText: String = "Aweh!!! What's poppin'?"
    
    func postStatus(status: String,
                    completion: @escaping Completion<StatusViewModel>,
                    error: @escaping Completion<String>) {
        
    }
    
}


