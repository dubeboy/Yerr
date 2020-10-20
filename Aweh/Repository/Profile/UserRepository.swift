//
//  UserRepository.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/17.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

// TODO: register these as new instance injectables and protocol interface these (REQUIREMENT FOR FULL INJECTION)
struct UserRepository: NewInstanceInjectable {
    
    @SingletonServiceInstance
    private var service: AwehService
//    @UserDefaultsBacked(key: AppStrings.Shared.UserDefaults.user, defaultValue: nil)
    
    var currentUser: User?
//    @UserDefaultsBacked(key: AppStrings.Shared.UserDefaults.user, defaultValue: false)
    var userNeedsUpdate: Bool = true
    
    var isUserLoggedIn: Bool {
        currentUser != nil
    }
    
    func getUserStatuses(userId: String, result: @escaping RepositoryResponseClousure<[Status]>) {
        service.$getUserStatuses(query: ["userId": userId]) { response in
            switch response {
                case .success(let user):
                    result(.success(user.body))
                case .failure(let error):
                    result(.failure(error))
            }
        }
    }
    
    func signInUser(user: User, result: @escaping RepositoryResponseClousure<User>) {
        service.$signInUser(body: user) { response in
            switch response {
                case .success(let user):
                    result(.success(user.body))
                    updateCachedUser(user: user.body.entity)
                case .failure(let error):
                    result(.failure(error))
            }
        }
    }
    
    func getIfUserExists(phoneNumber: String, result: @escaping RepositoryResponseClousure<User>) {
        service.$userExists(query: ["phone_number": phoneNumber]) { response in
            switch response {
                case .success(let user):
                    result(.success(user.body))
                    
                case .failure(let error):
                    result(.failure(error))
            }
        }
    }
    
    
    private func updateCachedUser(user: User?) {
        //                    currentUser = user.body
       //        userHasBeenUpdated = false
    }
    
    // this is called when ever when ever we make updates to the cahed user
    private func setUserNeedsUpdate() {
//        userHasBeenUpdated = true
    }
}
