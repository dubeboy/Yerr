//
//  EditVideoViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2021/01/05.
//  Copyright © 2021 com.github.aweh. All rights reserved.
//

import UIKit
import Photos

class EditPhotoViewController: UIViewController {
    var presenter: EditPhotoPresenter!
    var coordinator: EditPhotoCoordinator!
    
    private let imageView = UIImageView()
    private let outputLayer = CALayer()
    private var textViews = [UITextView]()
    
    @LateInit
    private var imagePreviewView: ImagesPreviewView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePreviewView = ImagesPreviewView(presenter: presenter.photosCollectionPresenter, delegate: self, phAssets: presenter.phAssets ?? [])
        configureSelf()
        configureImageView()
        configureImagePreview()
        if let imageData = presenter.imageData {
            imageView.image = UIImage(data: imageData)
        } else if let phAsset = presenter.phAssets {
            guard let asset = phAsset.first else { return }
            presenter.getPHAsset(asset: asset, targetSize: imageView.frame.size) { progress in
            } completion: { imageData in
                guard let imageData = imageData else { return }
                self.imageView.image = imageData
            }

        }
    }

    @objc func didTapAddText() {
        let overlayTextView = OverlayTextView(parent: imageView)
        overlayTextView.addToParent()
//        overlayTextView.textAlignment = .center
        textViews.append(overlayTextView)
        overlayTextView.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.endEditing(true)
        listenToEvent(
            name: .keyboardWillShow,
            selector: #selector(keyboardWillAppear(notification:))
        )
        
        listenToEvent(
            name: .keyboardWillHide,
            selector: #selector(keyboardWillHide(notification:))
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        removeSelfFromNotificationObserver()
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        //        guard let frame = keyboardFrame(from: notification) else { return }
        //        videoTextEditorBottomAnchor.constant = -Const.View.m16
        // use this to change the center of the text and then reset it back
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        guard keyboardFrame(from: notification) != nil else { return }
        //        videoTextEditorBottomAnchor.constant = -frame.size.height - Const.View.m16
        // use this to change the center of the text and then reset it back
        
    }
    
    @objc func  didTapEndEditing() {
        view.endEditing(true)
    }
    
    @objc func  didTapCreateImage() {
       let image = UIGraphicsImageRenderer(size: imageView.frame.size).image { ctx in // might have to be in background thread
            imageView.layer.render(in: ctx.cgContext)
       }
        
        guard let imageData = image.pngData() else {
            Logger.log("We could not create image and save failed")
            return
        }
        // We should also send all the info embeded in the image it self
        
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges {
                    let options = PHAssetResourceCreationOptions()
                    //                        options.shouldMoveFile = true // will  clean up manually
                    let creationRequest = PHAssetCreationRequest.forAsset()
                    creationRequest.addResource(with: .photo, data: imageData , options: options)
                } completionHandler: { (success, errror) in
                    if !success {
                        Logger.log("Could not save photo to you library \(String(describing: errror)) success: \(success) localized desc: \(errror)")
                    } else {
                        Logger.log("saved video")
                    }
                    //                        cleanup()
                }
                
            }
            //                cleanup()
        }
        
        presenter.postEditedImages(status: "Empty for now", images: [imageData]) {
            self.dismiss(animated: true, completion: nil)
        } failure: { errorMessage in
            self.presentToast(message: "Upload failed. please try again")
        }
        
    }
}

extension EditPhotoViewController {
    private func configureSelf() {
        
        addCloseButtonItem(toLeft: true)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Add Text", style: .plain, target: self, action: #selector(didTapAddText)),                UIBarButtonItem(title: "Create Image", style: .plain, target: self, action: #selector(didTapCreateImage))]
        
        imageView.autoresizingOff()
        view.addSubview(imageView)
        imageView --> view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapEndEditing))
        imageView.addGestureRecognizer(tapGesture)
        imageView.isUserInteractionEnabled = true
    }
    
    private func configureImageView() {
        imageView.contentMode = .scaleAspectFit
    }
    
    private func addImage(to layer: CALayer) {
        let image = imageView.image!
        let imageLayer = CALayer()
        
//        let aspect: CGFloat = image.size.width / image.size.height
        imageLayer.frame = imageView.frame
        imageLayer.contents = image.cgImage
        layer.addSublayer(imageLayer)
    }
    
    private func configureImagePreview() {
        imagePreviewView.autoresizingOff()
        view.addSubview(imagePreviewView)
        imagePreviewView.leadingAnchor --> view.leadingAnchor
        imagePreviewView.trailingAnchor --> view.trailingAnchor
        imagePreviewView.bottomAnchor --> view.safeAreaLayoutGuide.bottomAnchor
        imagePreviewView.heightAnchor --> ImagesPreviewView.IMAGE_PREVIEW_HEIGHT
    }
    
    private func addTextLayer(from textView: OverlayTextView) {
        let attributedText = NSAttributedString(string: textView.text + " - 000",  attributes: [
                                                    .font: UIFont(name: "ArialRoundedMTBold", size: 60) as Any,
                                                    .foregroundColor: UIColor.cyan,
                                                    .strokeColor: UIColor.white,
                                                    .strokeWidth: -3])
        
        let textLayer = CATextLayer()
        textLayer.string = attributedText
//        textLayer.shouldRasterize = true
//        textLayer.rasterizationScale = UIScreen.main.scale should also scale the frame as well
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = .center
        textLayer.frame = textView.frame
        textLayer.displayIfNeeded() // This is becuase UIView can async sometimes
        outputLayer.addSublayer(textLayer)
    }
}

extension EditPhotoViewController: ImagesPreviewViewDelegate {
    func didClickImage(_ photoAsset: [String : PHAsset]) {
        guard let asset = photoAsset.first?.value else { return }
        presenter.getPHAsset(asset: asset, targetSize: imageView.frame.size) { progress in
            // show progress here
        } completion: { imageData in
            
        }
    }
}
