//
//  IntrestsPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol IntrestsPresenter {
    var numberOfItems: Int { get }
    func fetchInterests(completion: @escaping () -> Void)
    func configure(cell: InterestsCollectionViewCell, at indexPath: IndexPath)
    func didSelect(at item: IndexPath, completion: (InterestViewModel) -> Void)
}

class IntrestsPresenterImplemantation: IntrestsPresenter {
    
    private var viewModel: [InterestViewModel]?
    private let interestCellPresenter = InterestsCellPresenter()
    
    var numberOfItems: Int {
        viewModel?.count ?? 0
    }
    
    func configure() {
        
    }
    
    func didSelect(at item: IndexPath, completion: (InterestViewModel) -> Void) {
        guard let viewModel = viewModel else { return }
        completion(viewModel[item.item])
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

extension IntrestsPresenterImplemantation {
    static func stub() -> [InterestViewModel] {
        dummy().map(InterestViewModel.transform(from:))
    }
    
    static func dummy() -> [Interest] {
        [
            Interest(interestName: "General", hasNewStatus: true, interestImageLink: "1"),
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
