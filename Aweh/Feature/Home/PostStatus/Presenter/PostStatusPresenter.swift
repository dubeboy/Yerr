//
//  PostStatusPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/07.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol PostStatusPresenter {
    var placeHolderText: String { get }
    var numberOfAllowedChars: String { get }
    
    func saveCurrentLocation(location: Location)
    
    func errorGettingLocation(error: Error)

    func postStatus(status: String?,
                    completion: @escaping Completion<StatusViewModel>,
                    error: @escaping Completion<String>)
    
}


struct PostStatusViewModel {
    
    let placeHolderText: String = "Aweh!!! What's poppin'?"
    let numberOfAllowedChars = 240
    var locationState: LocationStateViewModel = .waiting
    var currentLocation: Location? = nil {
        didSet {
            if currentLocation != nil {
                locationState = .success
            } else {
                locationState = .error
            }
        }
    }
}

class PostStatusPresenterImplementation: PostStatusPresenter {
    let feedInteractor = FeedInteractor()
    var viewModel = PostStatusViewModel()
    
    var placeHolderText: String {
        viewModel.placeHolderText
    }
    
    var numberOfAllowedChars: String {
        "\(viewModel.numberOfAllowedChars)"
    }
    
    func postStatus(status: String?,
                    completion: @escaping Completion<StatusViewModel>,
                    error: @escaping Completion<String>) {
        
        guard let status = status, !status.isEmpty else { return }
        
        // we should try to get the location if we cannnot get it
        // everytime the user signs in we cache their current location and
        // if we cannot get the current when the user is posting a new status
        // then we use the one that was cached when loggig in
        // cache and also update the server of the user current location
        // rememeber also its an atomic write when chaching the location
       
        let location = viewModel.currentLocation == nil ? {
            Logger.wtf("current location does not exist this is wrong!!! ")
            return Location.dummyLocation
        }() :  viewModel.currentLocation!
        
        let statusEntity = Status(id: nil, // add default value to make this shorter please!!!
                                  body: status,
                                  user: .dummyUser,
                                  comments: [],
                                  location: location,
                                  media: [],
                                  likes: 0,
                                  votes: 0,
                                  createdAt: Date())
        
        feedInteractor.postStatuses(status: statusEntity) { result in
            switch result {
                case .success(let success):
                    completion(.transform(from: success))
                case .failure(let e):
                    error(e.localizedDescription)
            }
        }
    }
    
    func saveCurrentLocation(location: Location) {
        viewModel.currentLocation = location
    }
    
    func errorGettingLocation(error: Error) {
        Logger.log(error)
        viewModel.currentLocation = nil
    }
    
    deinit {
        print("killed❌")
    }
    
}


