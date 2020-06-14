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
    
    var placeHolderText = "Aweh!!! What's poppin'?"
    weak var coordinator: PhotosGalleryCoordinator?
    
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

        statusTextView.text = placeHolderText
        statusTextView.textColor = .systemGray2
        statusTextView.delegate = self
        
        statusTextView.inputAccessoryView = createToolBar()
        statusTextView.sizeToFit()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillApear),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        statusTextView.becomeFirstResponder()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillApear(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
            as? NSValue else { return }
        let keyboardFrame = keyboardSize.cgRectValue
        
        statusTextBottomConstraint.constant = keyboardFrame.size.height + 8
    }
    
    
    // TODO: - move to the presenter
    @objc func getImages() {
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
    
    private func noAuthorised() {
       // show not authorise toast viewController
    }
    
    private func loadPhotos() {
        // test this out for string reference cycles
        coordinator?.startPhotosGalleryViewController { [weak self] assets in
            self?.didGetAssets(assets: assets) // tell presenter here!
        }
    }
    
    private func createToolBar() -> UIToolbar {
  
        let actionsToolBar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        actionsToolBar.barStyle = .default
       
        actionsToolBar.items = [
            UIBarButtonItem(title: "Add Images", style: .plain, target: self, action: #selector(getImages)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            // should be a custom UI progress UI
            UIBarButtonItem(title: "294/300", style: .plain, target: self, action: #selector(getImages))]
        return actionsToolBar
    }
    
    private func didGetAssets(assets: [String: PHAsset]) {
       let assetsView = AssetsHorizontalListView(assets: assets)
        let ass = assetsContainerView.subviews.last
        ass?.removeFromSuperview()
       assetsContainerView.addSubview(assetsView)
       assetsView --> assetsContainerView
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
    
    // TODO: 1 - the fact that the text is highlightable

    
    // https://grokswift.com/uitextview-placeholder/
    // https://tij.me/blog/adding-placeholders-to-uitextviews-in-swift/
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0
        {
            // check if the only text is the placeholder and remove it if needed
            if textView.text == placeHolderText
            {
                if text.utf16.count == 0 // they hit the back button
                {
                    return false // ignore it
                }
                applyNonPlaceholderStyle(textView)
                textView.text = ""
            }
        }
        else  // no text, so show the placeholder
        {
            applyPlaceholderStyle(textView, placeholderText: placeHolderText)
            moveCursorToFront(textView)
            return false
        }
        
        return true
    }
    
    private func applyPlaceholderStyle(_ textView: UITextView, placeholderText: String) {
        textView.text = placeholderText
        textView.textColor = UIColor.systemGray2
    }
    
    private func applyNonPlaceholderStyle(_ textView: UITextView) {
        textView.textColor = .black
    }
    
    
    private func moveCursorToFront(_ textView: UITextView) {
        textView.selectedRange = NSRange(location: 0, length: 0)
        
    }
}
