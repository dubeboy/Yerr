//
//  AwehService.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/04.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import Merchant

struct AwehService: Service {
        
    let baseURL: String = "http://localhost:8080/"
    var query = ["key" : "hdsdt662266gbeww666", "os": "ios"] // TODO: does not log this
    // TODO: pass back an static instace here? [Merchant]
    // TODO: prettiyfy

    // --------------------
    // MARK: Statuses
    // --------------------
    
    @GET("statuses")
    var getStatuses: StatusResponseEntity<[Status]>

    @PUT("statuses", body: Status.self)
    var postStatus: StatusResponseEntity<Status>
    
    @POST("statuses/like", body: VoteEntity.self)
    var postLike: StatusResponseEntity<Bool>
    
    @POST("statuses/vote", body: VoteEntity.self)
    var postVote: StatusResponseEntity<Bool>
    
    @POST("statuses/vote/delete", body: VoteEntity.self)
    var postRemoveVote: StatusResponseEntity<Bool>

    @POST("statuses/{status_id}/files", body: [MultipartBody].self, formURLEncoded: true)
    var postStatusMedia: StatusResponseEntity<Status>
    
    // --------------------
    // MARK: Status Comments
    // --------------------
    
    @GET("statuses/{status_id}/comments")
    var getComments: StatusResponseEntity<[Comment]>
    
    @POST("statuses/{status_id}/comments", body: Comment.self)
    var postComment: StatusResponseEntity<String>
    
    // --------------------
    // MARK: Circles
    // --------------------
    
    @GET("circles")
    var getAllCircles: StatusResponseEntity<[Interest]>
    
    @POST("circles/join", body: UserCircleRequestObject.self)
    var postJoinCircle: StatusResponseEntity<Bool>
    
    @GET("circles/my_circles")
    var getMyCircles: StatusResponseEntity<[Interest]>

    @GET("circles/statuses")
    var getStatusesForInterest: StatusResponseEntity<[Status]>
    
    // --------------------
    // MARK: User
    // --------------------
    
    @GET("users/statuses")
    var getUserStatuses: StatusResponseEntity<[Status]>
    
    @POST("users/signIn", body: User.self)
    var signInUser:  StatusResponseEntity<User>
    
    @GET("user_exists")
    var userExists: StatusResponseEntity<User>
    

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


