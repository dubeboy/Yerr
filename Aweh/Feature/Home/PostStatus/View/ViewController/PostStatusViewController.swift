//
//  PostStatusViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/07.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit
import Photos

class PostStatusViewController: UIViewController {
    
    var presenter: PostStatusPresenter!
    weak var coordinator: PhotosGalleryCoordinator?
    var delegate: Completion<StatusViewModel>!
    
    var placeHolderText: String {
        presenter.placeHolderText
    }
    
    @LateInit
    private var location: GeoLocationServices
    @LateInit
    private var numberOfCharactorsButton: UIBarButtonItem
    @LateInit
    private var bottomConstraint: NSLayoutConstraint
    
    var assets: [String: PHAsset] = [:]

    private var statusTextView: UITextView = UITextView()
    private var profileImage: UIImageView = UIImageView()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        location = GeoLocationServices(delegate: self)
        profileImage.makeImageRound()
        title = AppStrings.PostStatus.title
        configureSelf()
        setupStatusTextiew()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
    }
    
    @objc func post() {
        presenter.postStatus(status: status) { [weak self] status in
            guard let self = self else { return }
            self.close()
            self.delegate(status)
        } error: { errorMessage in
            self.presentToast(message: errorMessage)
        }
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        listenToEvent(
            name: .keyboardWillShow,
            selector: #selector(keyboardWillAppear(notification:))
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        commentBox.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeSelfFromNotificationObserver()
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        guard let frame = keyboardFrame(from: notification) else { return }
        // TODO: fix this is unaccaptable
        bottomConstraint.constant = -(frame.size.height - spookyKeyboardHeightConstant + 20)
    }
    
    
    // TODO: - move to the presenter
    @objc func requestAuthorisation() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
            case .authorized:
            loadPhotos() // ask coordinator to opne the grid view
            case .denied, .notDetermined:
            // request permission
            PHPhotoLibrary.requestAuthorization { [weak self] status in
                DispatchQueue.main.async {
                    if status == PHAuthorizationStatus.authorized {
                        self?.loadPhotos() // ask presenter to load photos
                    } else {
                        self?.noAuthorised() // tell presenter that its not auth
                    }
                }
            }
            default:
            noAuthorised()
        }
    }
    
    deinit {
        print("ahhhhhh❌") // TODO not being deinit!!!
    }
}

// MARK: PRIVATE Functions

extension PostStatusViewController {
    private func noAuthorised() {
        // TODO: fix it
        // show not authorise toast viewController // present actionable toast
        // show persist toast to take them to setting page where they can change these settings
        Logger.i("Not authonticated")
    }
    
    private func configureSelf() {
        view.addSubview(commentBox)
        setUpCommentBox()
    }
    
    private func setupStatusTextiew() {
        statusTextView.text = placeHolderText
        statusTextView.clipsToBounds = true
    }
    
    private func loadPhotos() {
        // TODO: - test this out for string reference cycles
        coordinator?.startPhotosGalleryViewController(navigationController: navigationController) { assets in
            self.didGetAssets(assets: assets) // tell presenter here!
        }
    }
    
    private func setUpCommentBox() {
        commentBox.replyButton.setTitle(AppStrings.PostStatus.postStatusButtonTitle, for: .normal)
        commentBox.placeHolderText = placeHolderText
        commentBox.translatesAutoresizingMaskIntoConstraints = false
        commentBox.topAnchor --> statusTextView.bottomAnchor + Const.View.m16
        bottomConstraint = commentBox.bottomAnchor --> view.safeAreaLayoutGuide.bottomAnchor
        commentBox.trailingAnchor --> view.trailingAnchor
        commentBox.leadingAnchor --> view.leadingAnchor
        commentBox.replyButton.addTarget(self, action: #selector(post), for: .touchUpInside)
        commentBox.selectPhotosButton.addTarget(self, action: #selector(requestAuthorisation), for: .touchUpInside)
    }
    
    private func didGetAssets(assets: [String: PHAsset]) {
        self.assets = assets
        presenter.appendSelectedImages(assets: assets)
        commentBox.showImageAssets(assets: assets)
    }
}

extension PostStatusViewController: GeoLocationServicesDelegate {
    
    func didFetchCurrentLocation(_ location: Location) {
        presenter.saveCurrentLocation(location: location)
    }
    
    func fetchCurrentLocationFailed(error: Error) {
        Logger.i(error)
        presentToast(message: AppStrings.Shared.GeoLocationServices.failedToGetLocation)
    }
    
}
