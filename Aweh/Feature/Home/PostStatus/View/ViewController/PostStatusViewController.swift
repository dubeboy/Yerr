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
    @LateInit
    private var actionsToolbarBottomConstraint: NSLayoutConstraint
    
    var assets: [String: PHAsset] = [:]

    private let profileImage: UIImageView = UIImageView()
    private let backgroundColorView = UIView()
    private let statusTextView = UITextView()
    private let actionsToolbar = UIToolbar()
    private let secondaryAcationsToolbar = UIToolbar()

    override func viewDidLoad() {
        super.viewDidLoad()
        location = GeoLocationServices(delegate: self)
        profileImage.makeImageRound()
        title = AppStrings.PostStatus.title
        configureSelf()
        configureStatusTextiew()
        configureActionsToolbar()
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
        actionsToolbarBottomConstraint.constant = -(Const.View.m16 + view.safeAreaInsets.bottom)
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        guard let frame = keyboardFrame(from: notification) else { return }
        bottomConstraint.constant = -frame.size.height
        actionsToolbarBottomConstraint.constant = -frame.size.height
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
    
    @objc func didTapDoneButton() {
        statusTextView.endEditing(true)
    }
    
    @objc func didChangeBackgroundColorButton() {
        statusTextView.endEditing(true)
    }
    
    @objc func didTapTextAlignment() {
        statusTextView.endEditing(true)
    }
    
    @objc func didTapBoldText() {
        statusTextView.endEditing(true)
    }
    
    @objc func didTapChangeTextbackground() {
        statusTextView.endEditing(true)
    }
    
    deinit {
        print("ahhhhhh❌") // TODO not being deinit!!!
    }
    
    @objc func closeViewController() {
        dismiss(animated: true, completion: nil)
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDoneButton))
        backgroundColorView.addGestureRecognizer(tapGesture)
        view.backgroundColor = .cyan
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeViewController))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(captureStatus))

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
    
    private func configureActionsToolbar() {
        actionsToolbar.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        actionsToolbar.autoresizingOff()
        view.addSubview(actionsToolbar)
        actionsToolbar.leadingAnchor --> view.leadingAnchor
        actionsToolbar.trailingAnchor --> view.trailingAnchor
        actionsToolbarBottomConstraint = actionsToolbar.bottomAnchor --> view.bottomAnchor + -(Const.View.m16 + view.safeAreaInsets.bottom)
        let doneButton = YerrButton(type: .system)
        doneButton.frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        doneButton.setTitle("Done", for: .normal)
        doneButton.autoresizesSubviews = true
        doneButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        doneButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        // TODO : style button here!!!
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(customView: doneButton)
        let barButtonBackgroundColor = UIBarButtonItem(image: Const.Assets.PostStatus.color, style: .plain, target: self, action: #selector(didChangeBackgroundColorButton))
        let batButtomTextAlignment = UIBarButtonItem(image: Const.Assets.PostStatus.textAlignmentCenter, style: .plain, target: self, action: #selector(didTapTextAlignment))
        let barButtonBoldText = UIBarButtonItem(image: Const.Assets.PostStatus.boldText, style: .plain, target: self, action: #selector(didTapBoldText))
        let barButtonChangeTextBackground = UIBarButtonItem(image: Const.Assets.PostStatus.changeTextBackground, style: .plain, target: self, action: #selector(didTapChangeTextbackground))
        
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = Const.View.m12
        
        actionsToolbar.setItems([barButtonBackgroundColor, fixedSpace, batButtomTextAlignment, fixedSpace, barButtonBoldText, fixedSpace, barButtonChangeTextBackground, spacer, barButton], animated: false)
    }
    
    private func configureSecondaryAcationsToolbar() {
        
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
//        textView.centerVerticalText()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.contentSize.height >= backgroundColorView.bounds.height {
            textView.isScrollEnabled = true
            statusTextTopConstraint.isActive = true // TODO: activate constrainst when need
            statusTextBottomConstraint.isActive = true
        } else {
            textView.isScrollEnabled = false
            statusTextTopConstraint.isActive = false
            statusTextBottomConstraint.isActive = false
        }
    }
}
