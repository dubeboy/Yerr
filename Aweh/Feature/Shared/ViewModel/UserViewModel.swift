//
//  UserViewModel.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/28.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import UIKit

struct UserViewModel: Hashable {
    let userImage: UIImage
    let userName: String
    let statuses: [StatusViewModel]
}
