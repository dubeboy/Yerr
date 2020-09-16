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
    
    var placeHolderText: String {
        presenter.placeHolderText
    }
   
    var numberOfCharactorsButton: UIBarButtonItem {
        UIBarButtonItem(title: presenter.numberOfAllowedChars, style: .plain, target: self, action: nil)
    }
        
    var postButton = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(post))
    var assets: [String: PHAsset] = [:]
   
    
    @IBOutlet weak var assetsContainerView: UIView!
    @IBOutlet weak var statusTextBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusTextView: UITextView!
    @IBOutlet weak var profileImage: UIImageView! {
        didSet {
            profileImage.makeImageRound()
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Post status"
        setupStatusTextiew()
        postButton.isEnabled = false
        navigationItem.rightBarButtonItem = postButton
        numberOfCharactorsButton.isEnabled = false
        numberOfCharactorsButton.setTitleTextAttributes(
                [NSAttributedString.Key.foregroundColor: UIColor.systemBlue],
                for: .disabled
        )
        location = GeoLocationServices(delegate: self)
       
    }
    
    private func setupStatusTextiew() {
        statusTextView.text = placeHolderText
        statusTextView.textColor = .systemGray2
        statusTextView.delegate = self
        statusTextView.inputAccessoryView = createToolBar()
        
    }
    
    @objc func post() {
        let status = statusTextView.text
        presenter.postStatus(status: status) { [weak self] status in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
            self.delegate(status)
        } error: { errorMessage in
            self.presentToast(message: errorMessage)
        }
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
        statusTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeSelfFromNotificationObserver()
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        guard let frame = keyboardFrame(from: notification) else { return }
        statusTextBottomConstraint.constant = frame.size.height - spookyKeyboardHeightConstant
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
        print("ahhhhhh❌")
    }
}

//MARK: - extension
extension PostStatusViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == placeHolderText {
            moveCursorToFront(textView)
        }
        return true
    }
    
    // TODO: - 1 fix the fact that the text is highlightable replace with a UIlabel
    // listen to end editing to get the final text and send to presenter
    // https://grokswift.com/uitextview-placeholder/
    // https://tij.me/blog/adding-placeholders-to-uitextviews-in-swift/
    func textView(_ textView: UITextView,
                  shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0 {
            if newLength > 240 {
                return false
            } else if textView.text == placeHolderText {
                if text.utf16.count == 0 {
                    postButton.isEnabled = false
                    return false
                }
                applyNonPlaceholderStyle(textView)
                textView.text = ""
            }
            postButton.isEnabled = true
            updateCharactorCount(length: newLength)
        } else {
            applyPlaceholderStyle(textView, placeholderText: placeHolderText)
            moveCursorToFront(textView)
            postButton.isEnabled = false
            return false
        }
        
        postButton.isEnabled = true
        return true
    }
    
    private func applyPlaceholderStyle(_ textView: UITextView, placeholderText: String) {
        textView.text = placeholderText
        textView.textColor = UIColor.systemGray2
    }
    
    private func applyNonPlaceholderStyle(_ textView: UITextView) {
        textView.textColor = UIColor(named: "textViewInputTextColor")
        textView.isSelectable = true
    }
    
    
    private func moveCursorToFront(_ textView: UITextView) {
        textView.selectedRange = NSRange(location: 0, length: 0)
        
    }
    
    private func updateCharactorCount(length: Int) {
        numberOfCharactorsButton.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: length > 200 ? UIColor.systemRed : UIColor.systemBlue], for: .disabled)
        numberOfCharactorsButton.title = "\((240)  - length)"
    }
}

// MARK: priate functions
extension PostStatusViewController {
    private func noAuthorised() {
        // TODO: fix it
        // show not authorise toast viewController // present actionable toast
    }
    
    private func loadPhotos() {
        // TODO: - test this out for string reference cycles
        coordinator?.startPhotosGalleryViewController { [weak self] assets in
            self?.didGetAssets(assets: assets) // tell presenter here!
        }
    }
    
    private func createToolBar() -> UIToolbar {
        
        let actionsToolBar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        actionsToolBar.barStyle = .default
        
        actionsToolBar.items = [
            UIBarButtonItem(title: "Add Images", style: .plain, target: self, action: #selector(requestAuthorisation)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            // should be a custom UI progress UI
            numberOfCharactorsButton]
        return actionsToolBar
    }
    
    private func didGetAssets(assets: [String: PHAsset]) {
        self.assets = assets
        let assetsView = AssetsHorizontalListView(assets: assets)
        let ass = assetsContainerView.subviews.last
        ass?.removeFromSuperview() // TODO: - the view should auto update instead of removing from superview
        assetsContainerView.addSubview(assetsView)
        assetsView --> assetsContainerView
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
