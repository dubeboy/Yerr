//
// Created by Divine.Dube on 2020/08/28.
// Copyright (c) 2020 com.github.aweh. All rights reserved.
//

import Foundation

enum FeedError: Error, LocalizedError {
    // Could be genralised for interactor be an error type of entity being nil
    case nilStatusesArray
    case noInternetConnection
    var errorDescription: String? {
        switch self {
        case .nilStatusesArray:
            return AppStrings.Error.genericError
        case .noInternetConnection:
            return  AppStrings.Error.noInternetConnection
        }
    }
}

enum UserError: Error {
    case userPhoneNumberIsRequired
    case currentUserIdIsNil
}
