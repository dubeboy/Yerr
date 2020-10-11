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
    func fetchInterests(completion: @escaping () -> Void, failure: @escaping (String) -> Void)
    func configure(cell: InterestsCollectionViewCell, at indexPath: IndexPath)
    func didSelect(at item: IndexPath, completion: (SelectAction) -> Void)
}

enum SelectAction {
    case multiSelect(selected: Bool)
    case select(InterestViewModel)
}

class InterestsPresenterImplemantation: InterestsPresenter {
    // inject user defaults here
    private var viewModel: [InterestViewModel] = []
    private let interestCellPresenter = InterestsCellPresenter()
    private let user: UserViewModel?
    private var selectedInterests: Set<InterestViewModel> = Set()
    private var circlesInteractor: CirclesUseCase = CirclesInteractor()
    
    var isMultiSelectEnabled: Bool {
        user != nil
    }
    
    init(user: UserViewModel? = nil) {
        self.user = user
    }
    
    var numberOfItems: Int {
        viewModel.count
    }
    
    func configure() {
        
    }
    
    func didSelect(at item: IndexPath, completion: (SelectAction) -> Void) {
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
        interestCellPresenter.configure(cell, with: viewModel[indexPath.item] )
    }
    
    func fetchInterests(completion: @escaping () -> Void,
                        failure: @escaping (String) -> Void) {
        circlesInteractor.getMyCircles(userId: User.dummyUser.id!) { response in
            switch response {
                case .success(let interests):
                    let interestsViewModel = InterestViewModel.transform(from: interests)
                    self.viewModel.append(contentsOf: interestsViewModel)
                    completion()
                case .failure(let error):
                    failure(error.localizedDescription)
            }
        }
    }
}
