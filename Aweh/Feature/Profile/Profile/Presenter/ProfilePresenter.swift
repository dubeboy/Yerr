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
    var viewModel: UserViewModel { get }
    var points: GuageViewViewModel? { get }
    var cellPresenter: CompactFeedPresenter { get }
    var numberOfStatuses: Int { get }
    
    func profileImage(completion: @escaping (UIImage) -> Void)
    func statuses(at index: IndexPath, completion: @escaping (StatusViewModel) -> Void)
}

class ProfilePresenterImplementation: ProfilePresenter {
   
    let viewModel: UserViewModel
    let cellPresenter: CompactFeedPresenter

    var points: GuageViewViewModel? {
        guard let guageViewModel = viewModel.point else {
            return nil
        }
        return guageViewModel
    }
    init() {
        self.viewModel = Self.mockUserViewModel()
        self.cellPresenter = CompactFeedPresenter()
    }
    
    func profileImage(completion: @escaping (UIImage) -> Void) {
        guard let userImage = viewModel.userImage else { return }
        completion(userImage)
    }
    
    func statuses(at index: IndexPath, completion: @escaping (StatusViewModel) -> Void) {
        completion(viewModel.statuses[index.item])
    }
    
    var numberOfStatuses: Int {
        viewModel.statuses.count
    }
    
    static func mockUserViewModel() -> UserViewModel {
        UserViewModel.transform(user: mockData())
    }
    
    static func mockData() -> User {
        User(
            name: "John",
            profilePictureUrl: "2",
            statuses: FeedPresenterImplemantation.status(),
            point: Point(type: .gold, scores: [10, 70, 78])
        )
    
    }
}
