//
//  IntrestsPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol InterestsPresenter {
    var numberOfItems: Int { get }
    var isMultiSelectEnabled: Bool { get }
    func fetchInterests(completion: @escaping () -> Void)
    func configure(cell: InterestsCollectionViewCell, at indexPath: IndexPath)
    func didSelect(at item: IndexPath, completion: (SelectAction) -> Void)
}

enum SelectAction {
    case multiSelect(selected: Bool)
    case select(InterestViewModel)
}

class InterestsPresenterImplemantation: InterestsPresenter {
    // inject user defaults here
    private var viewModel: [InterestViewModel]?
    private let interestCellPresenter = InterestsCellPresenter()
    private let user: UserViewModel?
    private var selectedInterests: Set<InterestViewModel> = Set()
    
    var isMultiSelectEnabled: Bool {
        user != nil
    }
    
    init(user: UserViewModel? = nil) {
        self.user = user
    }
    
    var numberOfItems: Int {
        viewModel?.count ?? 0
    }
    
    func configure() {
        
    }
    
    func didSelect(at item: IndexPath, completion: (SelectAction) -> Void) {
        guard let viewModel = viewModel else { return }
        switch isMultiSelectEnabled {
            case true:
                let interestItem = viewModel[item.item]
                let inserted = selectedInterests.insert(interestItem).inserted
                if !inserted { //
                    selectedInterests.remove(interestItem)
                }
                completion(.multiSelect(selected: inserted))
            default:
                completion(.select(viewModel[item.item]))
        }
    }
    
    func configure(cell: InterestsCollectionViewCell, at indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        interestCellPresenter.configure(cell, with: viewModel[indexPath.item] )
    }
    
    func fetchInterests(completion: @escaping () -> Void) {
        viewModel = Self.stub()
        completion()
    }
}

extension InterestsPresenterImplemantation {
    static func stub() -> [InterestViewModel] {
        dummy().map(InterestViewModel.transform(from:))
    }
    
    static func dummy() -> [Interest] {
        [
            Interest(interestName: "General",
                     hasNewStatus: true,
                     interestImageLink: "1",
                     users: [User(name: "John", profilePictureUrl: "2", statuses: FeedPresenterImplemantation.status()),
                             User(name: "Rahim Stelling", profilePictureUrl: "1", statuses: FeedPresenterImplemantation.status())
            ]),
            Interest(interestName: "Food", hasNewStatus: true, interestImageLink: "1"),
            Interest(interestName: "Morning Jog", hasNewStatus: false, interestImageLink: "2"),
            Interest(interestName: "Sale", hasNewStatus: true, interestImageLink: "1"),
            Interest(interestName: "Sports", hasNewStatus: false, interestImageLink: "1"),
            Interest(interestName: "Dating", hasNewStatus: true, interestImageLink: "1"),
            Interest(interestName: "Bussines", hasNewStatus: false, interestImageLink: "1"),
            Interest(interestName: "Ride Share", hasNewStatus: true, interestImageLink: "1"),
            Interest(interestName: "My Community", hasNewStatus: true, interestImageLink: "1"),
            Interest(interestName: "Comunity Sevices", hasNewStatus: true, interestImageLink: "1"),
        ]
    }
}
