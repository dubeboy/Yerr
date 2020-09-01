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
    // TODO: pass back an instace here?

    @GET("statuses")
    var getStatuses: StatusResponseEntity<[Status]>

    @POST("/statuses", body: Status.self)
    var postPost: StatusResponseEntity<Status>
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


