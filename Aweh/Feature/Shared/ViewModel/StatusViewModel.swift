//
//  HomeScreenViewModel.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/03.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

enum VoteDirectionViewModel {
    case up, down, none
}

struct ViewModelVoteEntity: Equatable, Hashable {
   let direction: VoteDirectionViewModel
   let hasReachedMaximumLikes: Bool = false
}

struct StatusViewModel: Equatable, Hashable, Identifiable {
    let id: String
    let status: String
    let user: UserViewModel
    let media: [MediaViewModel]
    let timeSincePosted: String
    var distanceFromYou: String = ""
    
    var voteEntity: ViewModelVoteEntity? = nil
    var likes: Int = 0
    var votes: Int = 0
//    var comments: Commen
}

extension StatusViewModel {

    private static func calculateDistanceFromMe(from location: Location) -> String {
        "--"
    }

    static func transform(from status: Status) -> Self {

        StatusViewModel(
                id: status.id ?? "",
                status: status.body,
                user: .transform(user: status.user), // TODO: should map to a Media viewModel
                media: status.media,
                timeSincePosted: status.createdAt.relativeDate()
        )
    }
    
    
}
