//
//  PostStatusViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/07.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit
import Photos

// This view gives you the ability to add text above a video or just normal text
// https://www.raywenderlich.com/5960-text-kit-tutorial-getting-started
// https://stackoverflow.com/questions/42842215/attributed-text-with-uitextfield
// https://www.xspdf.com/resolution/50437458.html
class PostStatusViewController: UIViewController {
    
    var presenter: PostStatusPresenter!
    weak var coordinator: (PhotosGalleryCoordinator & CaptureStatusCoordinator)!
    var delegate: Completion<StatusViewModel>!
    
    var placeHolderText: String {
        presenter.placeHolderText
    }
    
    @LateInit
    private var location: GeoLocationServices
    @LateInit
    private var bottomConstraint: NSLayoutConstraint
    @LateInit
    private var statusTextBottomConstraint: NSLayoutConstraint
    @LateInit
    private var statusTextTopConstraint: NSLayoutConstraint
    
    var assets: [String: PHAsset] = [:]

    private var profileImage: UIImageView = UIImageView()
    private let backgroundColorView = UIView()
    private var statusTextView = UITextView()

    override func viewDidLoad() {
        super.viewDidLoad()
        location = GeoLocationServices(delegate: self)
        profileImage.makeImageRound()
        title = AppStrings.PostStatus.title
        configureSelf()
        configureStatusTextiew()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(captureStatus))
        addCloseButtonItem(toLeft: true)
    }
    
    @objc func captureStatus() {
        coordinator.startCaptureStatusViewController(navigationController: navigationController)
    }
    
    
    @objc func post() {
//        presenter.postStatus(status: status) { [weak self] status in
//            guard let self = self else { return }
//            self.close()
//            self.delegate(status)
//        } error: { errorMessage in
//            self.presentToast(message: errorMessage)
//        }
    }
    
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        statusTextView.centerVerticalText()
        listenToEvent(
            name: .keyboardWillShow,
            selector: #selector(keyboardWillAppear(notification:))
        )
        
        listenToEvent(
            name: .keyboardWillHide,
            selector: #selector(keyboardWillHide(notification:))
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
       
        statusTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        statusTextView.endEditing(true)
        removeSelfFromNotificationObserver()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant = 0
//        statusTextBottomConstraint.constant = -(Const.View.m16 + view.safeAreaInsets.bottom)
//        statusTextBottomConstraint.constant = -Const.View.m16
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        guard let frame = keyboardFrame(from: notification) else { return }
        bottomConstraint.constant = -frame.size.height
//        statusTextBottomConstraint.constant = -Const.View.m16
//        statusTextBottomConstraint.constant = -frame.size.height - Const.View.m16
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
        backgroundColorView.autoresizingOff()
        view.addSubview(backgroundColorView)
        let (_, _, bottomBackgroundConstraint, _) = backgroundColorView --> view
        bottomConstraint = bottomBackgroundConstraint
        backgroundColorView.backgroundColor = .cyan
    }
    
    private func configureStatusTextiew() {
        statusTextView.autoresizingOff()
        backgroundColorView.addSubview(statusTextView)
        statusTextView.isScrollEnabled = false
        statusTextView.leadingAnchor --> backgroundColorView.leadingAnchor + Const.View.m16
        statusTextView.trailingAnchor --> backgroundColorView.trailingAnchor + -Const.View.m16
        statusTextView.centerYAnchor --> backgroundColorView.centerYAnchor
        statusTextView.text = "Hello there"
        statusTextView.delegate = self
        statusTextTopConstraint = statusTextView.topAnchor --> backgroundColorView.topAnchor + (Const.View.m16 + view.safeAreaInsets.top)
        statusTextBottomConstraint =  statusTextView.bottomAnchor -->  backgroundColorView.bottomAnchor + -Const.View.m16
        statusTextTopConstraint.isActive = false

        statusTextBottomConstraint.isActive = false
        statusTextView.backgroundColor = .clear
        statusTextView.textAlignment = .center
    }
    
    private func loadPhotos() {
        // TODO: - test this out for string reference cycles
        coordinator?.startPhotosGalleryViewController(navigationController: navigationController) { assets in
            self.didGetAssets(assets: assets) // tell presenter here!
        }
    }
    
    private func didGetAssets(assets: [String: PHAsset]) {
        self.assets = assets
        presenter.appendSelectedImages(assets: assets)
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

extension PostStatusViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.centerVerticalText()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height >= backgroundColorView.bounds.height {
            textView.isScrollEnabled = true
            statusTextTopConstraint.isActive = true
            statusTextBottomConstraint.isActive = true
        } else {
            textView.isScrollEnabled = false
            statusTextTopConstraint.isActive = false
            statusTextBottomConstraint.isActive = false
        }
    }
}
