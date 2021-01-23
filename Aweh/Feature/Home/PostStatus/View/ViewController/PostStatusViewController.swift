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
// https://pspdfkit.com/blog/2020/blur-effect-materials-on-ios/
// maybe we could allow the user add some maerials to their own contant and also add a materils background???
// definetly need so add some vibrancy and some diagnally cut background images
//https://developer.apple.com/documentation/uikit/uifont/scaling_fonts_automatically
//https://developer.apple.com/docume ntation/uikit/uiviewcontroller/1621430-presentingviewcontroller?language=objc // to blur the current view controller when images is shown
// add a recording timer
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
    private let gradientView = GradientView()
    @LateInit
    private var actionsToolbar: TextViewActionsView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        location = GeoLocationServices(delegate: self)
        actionsToolbar = TextViewActionsView(delegate: self, colors: presenter.colors)
        profileImage.makeImageRound()
        configureActionsToolbar()
        configureSelf()
        configureStatusTextiew()
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
        navigationController?.navigationBar.makeTransparent()
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
//        bottomConstraint.constant = 0
        actionsToolbarBottomConstraint.constant = -view.safeAreaInsets.bottom
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        guard let frame = keyboardFrame(from: notification) else { return }
//        bottomConstraint.constant = -frame.size.height
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
        if statusTextView.isFirstResponder {
            statusTextView.endEditing(true)
        } else {
            statusTextView.becomeFirstResponder()
        }
    }
    
    deinit {
        print("ahhhhhh❌") // TODO not being deinit!!!
    }
    
    @objc func closeViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
//        configureGradient()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

// MARK: - PRIVATE Functions

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
        backgroundColorView.backgroundColor = UIColor(hex: presenter.colors[0])
        backgroundColorView.leadingAnchor --> view.leadingAnchor
        backgroundColorView.clipsToBounds = true
//        backgroundColorView.layer.masksToBounds = true
        backgroundColorView.trailingAnchor --> view.trailingAnchor
        backgroundColorView.topAnchor --> view.safeAreaLayoutGuide.topAnchor + -(navigationController!.navigationBar.frame.height)
        bottomConstraint = backgroundColorView.bottomAnchor --> actionsToolbar.topAnchor + 40
        if UIDevice.current.hasNotch {
            backgroundColorView.layer.cornerRadius = 30
            backgroundColorView.smoothCornerCurve()
        }
        view.backgroundColor = UIColor(hex: "0B0B0B")
        addCloseButtonItem(toLeft: true)
        let button = createNavigationBarButton(image: Const.Assets.cameraIcon)
        button.addTarget(self, action: #selector(captureStatus), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        self.navigationController?.navigationBar.tintColor = Const.Color.navigationBarTintColor
        self.navigationController?.navigationBar.barStyle = .black
        configureGradient()
        view.sendSubviewToBack(backgroundColorView)
    }
    
    private func configureGradient() {
        gradientView.autoresizingOff()
        backgroundColorView.addSubview(gradientView)
        gradientView.backgroundColor = .red
        gradientView --> backgroundColorView
//        gradientView.isHidden = true // TODO: not best solution but will do for now
    }
    
    private func configureStatusTextiew() {
        statusTextView.autoresizingOff()
        backgroundColorView.addSubview(statusTextView)
        statusTextView.isScrollEnabled = false
        statusTextView.leadingAnchor --> backgroundColorView.leadingAnchor + Const.View.m16
        statusTextView.trailingAnchor --> backgroundColorView.trailingAnchor + -Const.View.m16
        statusTextView.centerYAnchor --> backgroundColorView.centerYAnchor
        statusTextView.heightAnchor ->= 50
        statusTextView.delegate = self
        statusTextTopConstraint = statusTextView.topAnchor --> backgroundColorView.topAnchor + (Const.View.m16 + view.safeAreaInsets.top)
        statusTextBottomConstraint =  statusTextView.bottomAnchor -->  backgroundColorView.bottomAnchor + -Const.View.m16
        statusTextTopConstraint.isActive = false
        statusTextBottomConstraint.isActive = false
        statusTextView.backgroundColor = .clear
        statusTextView.textAlignment = .center
        statusTextView.bringSubviewToFront(backgroundColorView)
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
    
    private func configureActionsToolbar() {
        actionsToolbar.autoresizingOff()
        view.addSubview(actionsToolbar)
        actionsToolbar.leadingAnchor --> view.leadingAnchor
        actionsToolbar.trailingAnchor --> view.trailingAnchor
        actionsToolbarBottomConstraint = actionsToolbar.bottomAnchor --> view.bottomAnchor
    }
}
//MARK: - GeoLocationServicesDelegate
extension PostStatusViewController: GeoLocationServicesDelegate {
    
    func didFetchCurrentLocation(_ location: Location) {
        presenter.saveCurrentLocation(location: location)
    }
    
    func fetchCurrentLocationFailed(error: Error) {
        Logger.i(error)
        presentToast(message: AppStrings.Shared.GeoLocationServices.failedToGetLocation)
    }
    
}
// MARK: - UITextViewDelegate
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

// MARK: - TextViewActionsView Delegate

extension PostStatusViewController: TextViewActionsViewDelegate {
    func didTapDoneActionButton() {
        view.endEditing(true)
    }
    
    func didTapTextAlignment(alignment: PostStatusViewModel.TextAlignment) {
        switch alignment {
            case .center:
                presenter.selectedTextAlignment = .center
                statusTextView.textAlignment = .center
            case .left:
                statusTextView.textAlignment = .left
                presenter.selectedTextAlignment = .left
            case .right:
                presenter.selectedTextAlignment = .right
                statusTextView.textAlignment = .right
        }
    }
    
    func didTapColorToChange(tag: Int) {
        if tag >= 0 {
            backgroundColorView.backgroundColor = UIColor(hex: presenter.colors[tag])
            gradientView.isHidden = true
        } else {
            gradientView.isHidden = false
        }
    }
    
    func didTapBoldText(textWeight: PostStatusViewModel.TextWeight) {
        switch textWeight {
            case .bold:
                    statusTextView.font = UIFont.boldSystemFont(ofSize: 16) // TODO: get these values from Const
            case .italic:
                    
                statusTextView.font = UIFont.italicSystemFont(ofSize: 16)

            case .normal:
                statusTextView.font = UIFont.systemFont(ofSize: 16)
        }
    }
}
