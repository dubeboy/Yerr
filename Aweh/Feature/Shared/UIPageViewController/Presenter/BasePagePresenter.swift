//
//  BasePagePresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/07/13.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

protocol BasePageablePresenter {
    associatedtype T: UIViewController
    func getFirstPageCount() -> Int
    func indexOf(viewController: T) -> Int?
    func viewController(at index: Int) -> T?
    func currentPagesCount() -> Int
}
