//
//  AwehService.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/04.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import Merchant

// this will this be a merchant service
struct AwehService: Service {
        
    let baseURL: String = "http://localhost:8080/api/v1"
    
    @GET("/posts")
    var getPosts: [Post]
    
    @POST("/posts", body: Post.self)
    var postPost: Post
}

struct AwehServiceInstance {
    
    @Autowired
    static var service: AwehService

    private init() {}
}


