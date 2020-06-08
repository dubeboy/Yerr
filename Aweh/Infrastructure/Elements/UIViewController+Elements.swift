//
//  UIViewController+Elements.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/08.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

extension UIViewController {
    func pushViewController<T: UIViewController>(_ fromNib: T) {
        let storyboard = UIStoryboard(name: String(describing: T.self), bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
        navigationController?.pushViewController(viewController, animated: true)
    }
}
