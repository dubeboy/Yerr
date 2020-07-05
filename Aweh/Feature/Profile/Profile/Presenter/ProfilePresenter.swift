//
//  ProfilePresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/04.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import UIKit

protocol ProfilePresenter {
    func profileImage(completion: @escaping (UIImage) -> Void)
    
    func statuses(completion: @escaping ([StatusViewModel]) -> Void)
}

class ProfilePresenterImplementation: ProfilePresenter {
    let viewModel: UserViewModel

    init() {
        self.viewModel = Self.mockUserViewModel()
    }
    
    func profileImage(completion: @escaping (UIImage) -> Void) {
        guard let userImage = viewModel.userImage else { return }
        completion(userImage)
    }
    
    func statuses(completion: @escaping ([StatusViewModel]) -> Void) {
        completion(viewModel.statuses)
    }
    
    static func mockUserViewModel() -> UserViewModel {
        UserViewModel.transform(user: mockData())
    }
    
    static func mockData() -> User {
            User(name: "John", profilePictureUrl: "2", statuses: FeedPresenterImplemantation.status())
         
            
    }
}
