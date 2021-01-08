//
//  PostStatusPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/07.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Photos
import Merchant // TODO should not import this here

protocol PostStatusPresenter {
    var colors: [String] { get }
    var textColors: [String] { get }
    var placeHolderText: String { get }
    var numberOfAllowedChars: String { get }
    var tagForDidTapBackgroundColor: Int { get }
    var tagForChangeTextAlignment: Int { get }
    var tagForBoldText: Int { get }
    var tagForChangeTextColor: Int { get }
    
    func saveCurrentLocation(location: Location)
    
    func errorGettingLocation(error: Error)

    func postStatus(status: String?,
                    completion: @escaping Completion<StatusViewModel>,
                    error: @escaping Completion<String>)
    
    func appendSelectedImages(assets: [String: PHAsset])
    
}


class PostStatusPresenterImplementation: PostStatusPresenter {
    
    let tagForDidTapBackgroundColor: Int = 1001
    let tagForChangeTextAlignment: Int = 2001
    let tagForBoldText: Int = 3001
    let tagForChangeTextColor: Int = 4001
    
    var colors: [String]
    var textColors: [String]
    
    let feedInteractor: StatusesUseCase = FeedInteractor()
    var viewModel = PostStatusViewModel()
   
    var placeHolderText: String {
        viewModel.placeHolderText
    }
    
    init() {
        colors = viewModel.colors
        textColors = viewModel.textColors
    }
    
    // is it still in use
    var numberOfAllowedChars: String {
    "\(Const.maximumTextLength)"
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
            Logger.wtf("current location does not exist this is wrong!!!, should not happen ")
            return Location.dummyLocation
        }() :  viewModel.currentLocation!
        
        let multipartBody = createMultipartBody()
        
        let statusEntity = Status(id: nil, // add default value to make this shorter please!!!
                                  body: status,
                                  user: .dummyUser,
                                  comments: [],
                                  location: location,
                                  media: [],
                                  likes: 0,
                                  votes: 0,
                                  createdAt: Date(),
                                  circleName: "Food") // Please change this
                
        feedInteractor.postStatuses(status: statusEntity, statusMultipart: multipartBody) { result in
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
    
    func appendSelectedImages(assets: [String: PHAsset]) {
        viewModel.selectedImages = assets
       
    }

    deinit {
        print("killed❌")
    }
    
}

// MARK: Private functions

extension PostStatusPresenterImplementation {
    private func createMultipartBody() -> [MultipartBody] {
        var multipartImages = [MultipartBody]()
        
        viewModel.selectedImages.forEach { (key, asset) in
            let manager = PHImageManager.default()
            let options = PHImageRequestOptions()
            options.version = .original // .current for edited one
            options.isSynchronous = true
            
            // TODO: assess memory leak
            if #available(iOS 13, *) {
                manager.requestImageDataAndOrientation(for: asset, options: options) { [self] (imageData, _, _, _) in
                    guard let multiFormData = createMultiPart(imageData: imageData) else {
                        Logger.i("Photos returned nil image")
                        Logger.log(AppStrings.Error.Analytics.photosReturnedNullImage)
                        return
                    }
                    multipartImages.append(multiFormData)
                }
            } else {
                manager.requestImageData(for: asset, options: options) { [self] imageData, _, _, _ in
                    guard let multiFormData = createMultiPart(imageData: imageData) else {
                        Logger.i("Photos returned nil image")
                        Logger.log(AppStrings.Error.Analytics.photosReturnedNullImage)
                        return
                    }
                    
                    multipartImages.append(multiFormData)
                }
            }
        }
        
        return multipartImages
    }
    
    private func createMultiPart(imageData: Data?) -> MultipartBody? {
        guard let imageData = imageData else {
            return nil
        }
        return MultipartBody(name: "files", body: imageData, filename: "\(UUID().uuidString).png", mime: "image/png")
    }
    
}

