//
//  InteractorResponseClousure.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/10.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

typealias InteractorResponseClousure<T> = (Result<T, Error>) -> Void
