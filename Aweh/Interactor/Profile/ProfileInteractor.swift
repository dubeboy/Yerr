//
//  User.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/22.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol ProfileInteractor {
    var isUserLoggedIn: Bool { get }
    
    func getUserIfExists(phoneNumber: String, result: @escaping InteractorResponseClousure<User>)
    func getUserStatuses(result: @escaping InteractorResponseClousure<[Status]>)
    func signIn(user: User, result: @escaping InteractorResponseClousure<User>)
}

class ProfileInteractorImplementation: ProfileInteractor {
   
    
    @InjectNewInstance
    private var userRepository: UserRepository

    
    var isUserLoggedIn: Bool {
        userRepository.isUserLoggedIn
    }
    
    func getUserIfExists(phoneNumber: String, result: @escaping InteractorResponseClousure<User>) {
        if let currentUser = userRepository.currentUser, !userRepository.userNeedsUpdate {
           return result(.success(currentUser))
        } else {
            guard !phoneNumber.isEmpty else {
                return result(.failure(UserError.userPhoneNumberIsRequired))
            }
            userRepository.getIfUserExists(phoneNumber: phoneNumber) { response in
                switch response {
                    case .success(let user):
                        guard let entity = user.entity else {
                            return result(.failure(FeedError.nilStatusesArray))
                        }
                        result(.success(entity))
                    case .failure(let error):
                        Logger.log(error)
                        return result(.failure(FeedError.noInternetConnection))
                }
            }
        }
    }
    
    func getUserStatuses(result: @escaping InteractorResponseClousure<[Status]>) {
        
        guard let currentUser = userRepository.currentUser, let userId = currentUser.id else {
            return result(.failure(UserError.currentUserIdIsNil))
        }
        
        userRepository.getUserStatuses(userId: userId) { response in
            switch response {
                case .success(let status):
                    guard let entity = status.entity else {
                        return result(.failure(FeedError.nilStatusesArray))
                    }
                    result(.success(entity))
                case .failure(let error):
                    Logger.log(error)
                    return result(.failure(FeedError.noInternetConnection))
            }
        }
    }
    
    func signIn(user: User, result: @escaping InteractorResponseClousure<User>) {
        userRepository.signInUser(user: user) { response in
            switch response {
                case .success(let user):
                    guard let entity = user.entity else {
                        return result(.failure(FeedError.nilStatusesArray))
                    }
                    result(.success(entity))
                case .failure(let error):
                    Logger.log(error)
                    return result(.failure(FeedError.noInternetConnection))
            }
        }
    }
}
