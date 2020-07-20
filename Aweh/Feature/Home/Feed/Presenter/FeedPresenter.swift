//
//  FeedPresenterImplemantation.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/03.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol FeedPresenter {
    var statusCount: Int { get }
    
    func getStatuses(status: @escaping (_ status: [StatusViewModel]) -> Void)
    func getStatus(at index: IndexPath) -> StatusViewModel
    
    var feedCellPresenter: FeedCellPresenter { get }
    
    func index(for item: StatusViewModel) -> Int

}

protocol StoriesPresenter {
    
}

class FeedPresenterImplemantation {
    
    var feedCellPresenter: FeedCellPresenter = FeedCellPresenter()
    
//    should have a init with status object
    
}

extension FeedPresenterImplemantation: FeedPresenter {
    func index(for item: StatusViewModel) -> Int {
        fatalError("should be called later")
    }
    
    func getStatus(at index: IndexPath) -> StatusViewModel {
        fatalError("should be called later")
    }
    
    var statusCount: Int {
        fatalError("should be called later")
    }
    
    func getStatuses(status: @escaping (_ status: [StatusViewModel]) -> Void) {
//        status()
    }
}
