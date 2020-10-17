//
//  ProfilePresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/04.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import UIKit

enum UserFailureType {
    case pleaselogin(String), generic(String)
}

protocol ProfilePresenter {
    var cellPresenter: CompactFeedPresenter { get }
    var numberOfStatuses: Int { get }
    func getCurrentUser(completion: @escaping (UserViewModel) -> Void, failure: @escaping Completion<UserFailureType>)
    func getCurrentUser(phoneNumber: String, completion: @escaping (UserViewModel) -> Void, failure: @escaping Completion<UserFailureType>)
    func getStatuses(completion: @escaping (Int) -> Void, failure: @escaping (UserFailureType) -> Void)
    func status(at indexPath: IndexPath) -> StatusViewModel?
    func signIn(user: User, completion: @escaping (Bool) -> Void, failure: @escaping Completion<UserFailureType>)
}


class ProfilePresenterImplementation: ProfilePresenter {
    
    
    private var viewModel: UserViewModel?
    let cellPresenter: CompactFeedPresenter
    let userInteractor: ProfileInteractor = ProfileInteractorImplementation()
    
    init() {
//        self.viewModel = Self.mockUserViewModel()
        self.cellPresenter = CompactFeedPresenter()
    }
    
    func isUserLoggedIn() -> Bool {
        return false
    }
    
    func signIn(user: User, completion: @escaping (Bool) -> Void, failure: @escaping Completion<UserFailureType>) {
        userInteractor.signIn(user: user) { [self] response in
            switch response {
                case .success(let user):
                    viewModel = UserViewModel.transform(user: user)
                    completion(true)
                case .failure(let error):
                    switch error {
                        case UserError.currentUserIdIsNil:
                            failure(.pleaselogin(error.localizedDescription))
                        case UserError.userPhoneNumberIsRequired:
                            failure(.pleaselogin(error.localizedDescription))
                        default:
                            failure(.generic(error.localizedDescription))
                    }
            }
        }
    }
    
    private func getCurrentUser(_ phoneNumber: String, _ completion: @escaping (UserViewModel) -> Void, _ failure: @escaping Completion<UserFailureType>) {
        userInteractor.getUserIfExists(phoneNumber: phoneNumber) { [self] response in
            switch response {
                case .success(let user):
                    viewModel = UserViewModel.transform(user: user)
                    completion(viewModel!)
                case .failure(let error):
                    switch error {
                        case UserError.currentUserIdIsNil:
                            failure(.pleaselogin(error.localizedDescription))
                        case UserError.userPhoneNumberIsRequired:
                            failure(.pleaselogin(error.localizedDescription))
                        default:
                            failure(.generic(error.localizedDescription))
                    }
            }
        }
    }
    
    func getCurrentUser(phoneNumber: String, completion: @escaping (UserViewModel) -> Void, failure: @escaping Completion<UserFailureType>) {
        getCurrentUser(phoneNumber, completion, failure)
    }
    
    func getCurrentUser(completion: @escaping (UserViewModel) -> Void, failure: @escaping Completion<UserFailureType>) {
        getCurrentUser("", completion, failure)
    }
    
    func status(at indexPath: IndexPath) -> StatusViewModel? {
        guard let viewModel = viewModel?.statuses[indexPath.item] else {
            Logger.log(AppStrings.Error.Profile.IncositentViewModel)
            return nil
        }
        return viewModel
    }
    
    var numberOfStatuses: Int {
        viewModel?.statuses.count ?? 0
    }
    
    
    
    func getStatuses(completion: @escaping (Int) -> Void, failure: @escaping (UserFailureType) -> Void) {
        userInteractor.getUserStatuses { [self] response in
            switch response {
                case .success(let statuses):
                    guard var viewModel = viewModel else {
                        return failure(.pleaselogin(AppStrings.Profile.pleaseSignIn))
                    }
                    viewModel.statuses.append(contentsOf: statuses.map(StatusViewModel.transform(from:)))
                    completion(viewModel.statuses.count)
                case .failure(let error):
                    failure(.generic(error.localizedDescription))
            }
        }
    }
}
