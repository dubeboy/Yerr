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
    
    @LateInit
    var location: GeoLocationServices
    @LateInit
    var numberOfCharactorsButton: UIBarButtonItem
    @LateInit
    var commentBox: CommentBoxView
    
    var placeHolderText: String {
        presenter.placeHolderText
    }
    
//    var postButton = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(post))
    var postButton = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closs))

    var assets: [String: PHAsset] = [:]

    var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.makeImageRound()
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        location = GeoLocationServices(delegate: self)
        commentBox = CommentBoxView(displayType: .compact(statusTextView))
        commentBox.placeHolderText = placeHolderText
        title = "Post status"
        setupStatusTextiew()
        configureSelf()
        navigationItem.rightBarButtonItem = postButton       
    }
    
    private func configureSelf() {
        view.addSubview(commentBox)
        commentBox.translatesAutoresizingMaskIntoConstraints = false
        commentBox.topAnchor --> statusTextView.bottomAnchor + Const.View.m16
        bottomConstraint = commentBox.bottomAnchor --> view.safeAreaLayoutGuide.bottomAnchor
        commentBox.trailingAnchor --> view.trailingAnchor
        commentBox.leadingAnchor --> view.leadingAnchor
        commentBox.replyButton.addTarget(self, action: #selector(post), for: .touchUpInside)
        commentBox.selectePhotosButton.addTarget(self, action: #selector(requestAuthorisation), for: .touchUpInside)
    }
    
    private func setupStatusTextiew() {
        statusTextView.text = placeHolderText
        statusTextView.clipsToBounds = true
    }
    
    @objc func post() {
        let status = commentBox.commentText()
        presenter.postStatus(status: status) { [weak self] status in
            guard let self = self else { return }
            self.closs()
            self.delegate(status)
        } error: { errorMessage in
            self.presentToast(message: errorMessage)
        }
    }
    
    @objc private func closs() {
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
             // you are restricted fo  accessing from images
            noAuthorised()
        }
    }
    
    deinit {
        print("ahhhhhh❌") // TODO not being deinit!!!
    }
}

// MARK: priate functions
extension PostStatusViewController {
    private func noAuthorised() {
        // TODO: fix it
        // show not authorise toast viewController // present actionable toast
        Logger.i("Not authonticated")
    }
    
    private func loadPhotos() {
        // TODO: - test this out for string reference cycles
        coordinator?.startPhotosGalleryViewController(navigationController: navigationController) { [weak self] assets in
            self?.didGetAssets(assets: assets) // tell presenter here!
        }
    }
    
    private func setUpCommentBox(){
        commentBox.placeHolderText = placeHolderText
    }
    
    private func didGetAssets(assets: [String: PHAsset]) {
        self.assets = assets
//        let assetsView = AssetsHorizontalListView(assets: assets)
//        let ass = assetsContainerView.subviews.last
//        ass?.removeFromSuperview() // TODO: - the view should auto update instead of removing from superview
//        assetsContainerView.addSubview(assetsView)
//        assetsView --> assetsContainerView
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
