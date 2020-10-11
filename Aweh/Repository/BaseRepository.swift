//
//  BaseRepository.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/04.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

typealias RepositoryResponseClousure<T: Codable> = (Result<StatusResponseEntity<T>, Error>) -> Void

protocol BaseRepository {
    // use extension to get static instaces
}


