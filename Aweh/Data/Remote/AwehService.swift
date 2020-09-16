//
//  AwehService.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/04.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import Merchant

// TODO: use extensions ti break these up group them with their repos
struct AwehService: Service {
        
    let baseURL: String = "http://localhost:8080/"
    var query = ["key" : "hdsdt662266gbeww666", "os": "ios"]
    // TODO: pass back an static instace here? [Merchant]

    /// --------------------
    // MARK: Statuses
    /// --------------------
    
    @GET("statuses")
    var getStatuses: StatusResponseEntity<[Status]>

    @PUT("statuses", body: Status.self)
    var postStatus: StatusResponseEntity<Status>
    
    /// --------------------
    // MARK: Status Comments
    /// --------------------
    
    @GET("statuses/{status_id}/comments")
    var getComments: StatusResponseEntity<[Comment]>
    
    @POST("statuses/{status_id}/comments", body: Comment.self)
    var postComment: StatusResponseEntity<String>
    
}


/// We maintain a static reference to our service
@propertyWrapper
struct SingletonServiceInstance {
    
    @Autowired
    static var service: AwehService

    var wrappedValue: AwehService {
        Self.service
    }
}


