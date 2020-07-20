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
        
    let baseURL: String = "http://192.168.88.251/api-docs"
    
    @GET("/posts")
    var getPosts: [Post]
    
    @POST("/posts", body: Post.self)
    var postPost: Post
}

class AwehServiceInstance {
    
    @Autowired
    static var service: AwehService
    
    let instance: AwehServiceInstance = AwehServiceInstance()
    
    private init() {}
}


