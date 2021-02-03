//
//  CaptureStatusViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/28.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

//https://medium.com/@barbulescualex/making-a-custom-camera-in-ios-ea44e3087563
//https://gist.github.com/yusuke024/b5cd3909d9d7f9e919291491f6b381f0
// create a small image preview view that shows up above the capture button
// record the number od people use this screen to just selecl an image from gallary and those who take picture
// also drop out rate from taking image and not sending it
// Change videoGravity by folloing the HIGs 
class CaptureStatusViewController: UIViewController {
    
    // MARK: Session Management
    
    private enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }
    
    private enum CaptureMode {
        case photo, movie
    }

    var coordinator: (PhotosGalleryCoordinator & TrimVideoCoordinator & EditPhotoCoordinator)!
    var presenter: CaptureStatusPresenter!
    
    private var captureButton = CaptureButton()
    private var openGalleryButton = YerrButton()
    
    private var captureSession = AVCaptureSession()
    
    private var inProgressPhotoCaptureDelegates = [Int64: PhotoCaptureProcessor]()
    
    @objc dynamic var videoDeviceInput: AVCaptureDeviceInput!
    
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private let photoOutput = AVCapturePhotoOutput()
    private var movieFileOutput: AVCaptureMovieFileOutput!
    private var captureMode = CaptureMode.photo
    private var switchCameraButton: YerrButton = YerrButton()
         
    private let overlayView = UIView()
    private let overlayLabel = UILabel()
    
    private let sessionQueue = DispatchQueue(label: "session queue")
    private var isSessionRunning = false
    
    private var setupResult: SessionSetupResult = .success
    
    private var backgroundRecordingID: UIBackgroundTaskIdentifier?
    
    private let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [
                                                                                .builtInWideAngleCamera,
                                                                                .builtInDualCamera,
                                                                                .builtInTrueDepthCamera],
                                                                               mediaType: .video, position: .unspecified)
    
    private let dragView = UIView() // This should have a disappeating text view with instruction
    private let dragImage = UIView()
    private var backgroundView: UIView = UIView()
    
    private var imagePreviewHeightConstraint: NSLayoutConstraint?
    
    @LateInit
    private var imagesPreview: ImagesPreviewView
    
    private static let ACTION_BUTTON_BUTTON_SIZE: CGFloat = 40
    private static let CAPTURE_BUTTON_SIZE: CGFloat = 60
    
    private let selectButton: YerrButton = YerrButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        imagesPreview = ImagesPreviewView(presenter: presenter.photosCollectionViewPresenter, delegate: self)
        configureSelf()
        configureCaptureButton()
        configureOpenGalleryButton()
        configureSwitchCameraButton()
        configureOverlayView()
        setupPreviewLayer()
        configureCaptureSession()
        configureImagesPreview()
        configureDraggableImage()
        checkCameraPermission()
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.makeTransparent()
        switch setupResult {
            case .success:
                startCaptureSession()
            case .notAuthorized:
                presentNotAuthorised(message: AppStrings.CaptureStatus.permissionToCameraNotGranted)
            case .configurationFailed:
                let okAction = UIAlertAction(title: AppStrings.CaptureStatus.alertOk, style: .cancel, handler: nil)
                Logger.log(AppStrings.Error.CaptureStatus.configrationFailed)
                presentAlert(title: AppStrings.CaptureStatus.alertTitle, message: AppStrings.CaptureStatus.configrationFailed, actions: okAction)
        }
            
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.removeTransparency()
        stopCaptureSession()
        imagePreviewHeightConstraint?.constant = ImagesPreviewView.IMAGE_PREVIEW_HEIGHT
        self.imagesPreview.isHidden = false
        self.presenter.isImageDrawerClosed = false
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.layoutIfNeeded()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { // could change the alpha instead of drawingb the view
            UIView.animate(withDuration:  0.25, delay: 0.5, options: []) {
                self.imagePreviewHeightConstraint?.constant = 0
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.imagesPreview.isHidden = true
               
            }
        }
        self.presenter.isImageDrawerClosed = true
    }

    @objc func switchCamera() {
        switchCameraInput()
    }
    
    @objc func takePictureAction() {
        captureMode = .photo
        Logger.i("Taking picture")
        sessionQueue.async {
            // no need to set the video orintation its set in the output!!!
            
            var photoSettings = AVCapturePhotoSettings()
            
            if self.photoOutput.availablePhotoCodecTypes.contains(.hevc) {
                photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.hevc])
            }
            
            if self.videoDeviceInput.device.isFlashAvailable {
                photoSettings.flashMode = .auto // TODO: have a button to toggle this please
            }
            
            photoSettings.isHighResolutionPhotoEnabled = true
            if !photoSettings.__availablePreviewPhotoPixelFormatTypes.isEmpty {
                photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: photoSettings.__availablePreviewPhotoPixelFormatTypes.first!]
            }
            
            if #available(iOS 13.0, *) {
                photoSettings.photoQualityPrioritization = .balanced
            }
            
            let photoProcessor = PhotoCaptureProcessor(with: photoSettings, willCapturePhotoAnimation: {
                DispatchQueue.main.async {
                    self.flashScreen(completion: { _ in })
                }
            }, livePhotoCaptureHandler: { capturing in
                
                    
            }, completionHandler: { photoProcessor, data in
                self.sessionQueue.async {
                    self.inProgressPhotoCaptureDelegates[photoProcessor.requestedPhotoSettings.uniqueID] = nil
                }
                DispatchQueue.main.async {
                    guard let data = data else { return }
                   // TODO: show progress bar here
                    self.coordinator.startEditPhotoCoordinator(navigationController: self.navigationController, imageAssetData: data)
                }
            }, photoProcessingHandler: { animate in
                DispatchQueue.main.async {
                    if animate {
                        Logger.i("animating photo")
                    }
                }
                
               
            })
            
            self.inProgressPhotoCaptureDelegates[photoProcessor.requestedPhotoSettings.uniqueID] = photoProcessor
            self.photoOutput.capturePhoto(with: photoSettings, delegate: photoProcessor)
            
        }
    }
    
    @objc func dragImagePreview(_ sender: UIPanGestureRecognizer) {
        let velocity = sender.velocity(in: view)
        let translation = sender.translation(in: view)
        
        if velocity.y < -200 && presenter.isImageDrawerClosed {
            UIView.animate(withDuration:  0.25) {
                self.imagePreviewHeightConstraint?.constant = ImagesPreviewView.IMAGE_PREVIEW_HEIGHT
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.imagesPreview.isHidden = false
            }
            if sender.state == .ended {
                self.presenter.isImageDrawerClosed = false
                UIView.animate(withDuration: 0.3) { [self] in
                    self.imagesPreview.transform = .identity
                }
            }
        } else if velocity.y > 200 {
            UIView.animate(withDuration:  0.25) {
                self.imagePreviewHeightConstraint?.constant = 0
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.imagesPreview.isHidden = true
            }
            if sender.state == .ended {
                self.presenter.isImageDrawerClosed = true
            }
        } else if velocity.y < -200 && !presenter.isImageDrawerClosed {
            // TODO: translate image to an up arrow and then after open image selector
            let translatePercentage = abs(translation.y / view.frame.height)
            self.imagesPreview.transform = CGAffineTransform(scaleX: 1 + translatePercentage , y: 1 + translatePercentage)
            if translatePercentage >= 0.15 {
                coordinator.startPhotosGalleryViewController(navigationController: self.navigationController, completion: handleSelectedImageCompletion)
                UIView.animate(withDuration: 0.3) { [self] in
                    self.imagesPreview.transform = .identity
                }
            }
            if sender.state == .ended {
                UIView.animate(withDuration: 0.3) { [self] in
                    self.imagesPreview.transform = .identity
                }
            }
        }
    }
    
    @objc func takeVideoAction(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state == .began {
            Logger.i("state began")
            captureMode = .movie
            toggleCaptureMode() // TODO: remove this it is not needed!!!!
            recordVideo()
        } else if gestureReconizer.state == .ended {
            Logger.i("state ended")
            stopRecordingVideo()
        }
    }
    
    func startEditPhotoViewController(phAssets: [PHAsset]) {
        coordinator.startEditPhotoCoordinator(navigationController: navigationController, phAsset: phAssets)
    }
    
    @objc func openGalleryAction() {
        coordinator.startPhotosGalleryViewController(navigationController: navigationController,
                                                     completion: handleSelectedImageCompletion)
    }
    
    private func handleSelectedImageCompletion(_ photoAsset: [PHAsset]) {
        guard let phAsset = photoAsset.first else { return }
        if phAsset.mediaType == .video {
            coordinator.startTrimVideoViewController(navigationController: navigationController, photoAsset: phAsset)
        } else {
            self.startEditPhotoViewController(phAssets: photoAsset)
        }
    }
    
    @objc func sessionWasInterrupted(notification: NSNotification) {
        let userInfoValue = notification.userInfo?[AVCaptureSessionInterruptionReasonKey] as AnyObject
        if let reasonIntegerValue = userInfoValue.integerValue,
           let reason = AVCaptureSession.InterruptionReason(rawValue: reasonIntegerValue) {
            Logger.i(AppStrings.Error.CaptureStatus.cameraPaused)
            
            var showResumeButton = false
            if reason == .audioDeviceInUseByAnotherClient || reason == .videoDeviceInUseByAnotherClient {
                showResumeButton = true
            } else if reason == .videoDeviceNotAvailableWithMultipleForegroundApps {
                overlayView.isHidden = false
                overlayLabel.alpha = 0
                overlayLabel.text = AppStrings.CaptureStatus.videoRecPausedAudioInUse
                
                UIView.animate(withDuration: 0.25) {
                    self.overlayLabel.alpha = 1
                }
            } else if reason == .videoDeviceNotAvailableDueToSystemPressure {
                Logger.log(AppStrings.Error.CaptureStatus.phoneIsOverHeating)
                presentToast(message: AppStrings.CaptureStatus.phoneIsOverHeating)
            }
            
            if showResumeButton {
                overlayView.isHidden = false
                overlayLabel.alpha = 0
                overlayLabel.text = AppStrings.CaptureStatus.cameraPausedTapToResume
                UIView.animate(withDuration: 0.25) {
                    self.overlayLabel.alpha = 1
                }
            }
        }
    }
    
    @objc func didTapToResumeCamera() {
        
    }
    
    @objc func popViewController() {
        coordinator.pop()
    }
    
    @objc func sessionRuntimeError(notification: NSNotification) {
        guard let error = notification.userInfo?[AVCaptureSessionErrorKey] as? AVError else { return }
        if error.code == .mediaServicesWereReset {
            sessionQueue.async {
                if self.isSessionRunning {
                    self.captureSession.startRunning()
                    self.isSessionRunning = self.captureSession.isRunning
                } else {
                    DispatchQueue.main.async {
                        self.overlayView.isHidden = false
                    }
                }
            }
        } else {
            self.overlayView.isHidden = false
        }
        
    }
    
    @objc func sessionInterruptionEnded() {
        Logger.i(AppStrings.Error.CaptureStatus.cameraResumed)
        
        if !overlayView.isHidden {
            UIView.animate(withDuration: 0.25) {
                self.overlayView.alpha = 0
            } completion: { _ in
                self.overlayView.isHidden = true
            }
        }
    }
    
    @objc func subjectAreaDidChange() {
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // TODO: check SystemPressureState here to lower frame rate!!!
    
    deinit {
        Logger.i("Killed CaptureStatus")
    }
    
}

//
// MARK: - Private View helper functions
//

private extension CaptureStatusViewController {
    func configureSelf() {
        addCloseButtonItem(toLeft: true)
        
        self.navigationController?.navigationBar.tintColor = Const.Color.navigationBarTintColor
    }
    
  
    
    private func setupPreviewLayer() {
        backgroundView.autoresizingOff()
        backgroundView.backgroundColor = .brown
        view.addSubview(backgroundView)
        if UIDevice.current.hasNotch {
            backgroundView.layer.cornerRadius = Const.View.viewCornerRadius
            backgroundView.smoothCornerCurve()
        }
        view.backgroundColor = Const.Color.roundViewsBackground
        backgroundView.leadingAnchor --> view.leadingAnchor
        backgroundView.trailingAnchor --> view.trailingAnchor
        backgroundView.topAnchor --> view.safeAreaLayoutGuide.topAnchor + -navigationController!.navigationBar.frame.height
        backgroundView.bottomAnchor --> view.safeAreaLayoutGuide.bottomAnchor
        backgroundView.clipsToBounds = true
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        backgroundView.layer.insertSublayer(previewLayer, below: captureButton.layer)
        previewLayer.frame = self.view.layer.frame

    }
    
    func configureCaptureButton() {
        captureButton.autoresizingOff()
        backgroundView.addSubview(captureButton)
        captureButton.bottomAnchor --> backgroundView.bottomAnchor + -Const.View.m16 * 2
        captureButton.centerXAnchor --> backgroundView.centerXAnchor
        captureButton.widthAnchor --> Self.CAPTURE_BUTTON_SIZE
        captureButton.heightAnchor --> Self.CAPTURE_BUTTON_SIZE
        captureButton.addTarget(self, action: #selector(takePictureAction), for: .touchUpInside)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(takeVideoAction))
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.delaysTouchesBegan = true
        captureButton.addGestureRecognizer(longPressRecognizer)
        // add long press to rec
    }
    
    private func configureSwitchCameraButton() {
        switchCameraButton.autoresizingOff()
        switchCameraButton.addTarget(self, action: #selector(switchCamera), for: .touchUpInside)
        switchCameraButton.setImage(fillBoundsWith: Const.Assets.CaptureStatus.cameraRotate?.withRenderingMode(.alwaysTemplate))
        switchCameraButton.tintColor = Const.Color.CaptureStatus.captureButton
        backgroundView.addSubview(switchCameraButton)
        switchCameraButton.heightAnchor --> Self.ACTION_BUTTON_BUTTON_SIZE
        switchCameraButton.widthAnchor --> Self.ACTION_BUTTON_BUTTON_SIZE
        switchCameraButton.trailingAnchor -->  backgroundView.trailingAnchor + -Const.View.m16
        switchCameraButton.centerYAnchor --> captureButton.centerYAnchor
    }
    
    private func configureOpenGalleryButton() {
        openGalleryButton.autoresizingOff()
        backgroundView.addSubview(openGalleryButton)
        openGalleryButton.setImage(fillBoundsWith: Const.Assets.CaptureStatus.openGalleryIcon?.withRenderingMode(.alwaysTemplate))
        openGalleryButton.tintColor = Const.Color.CaptureStatus.captureButton // TODO: make button a bit thick
        openGalleryButton.leadingAnchor --> backgroundView.leadingAnchor + Const.View.m16
        openGalleryButton.centerYAnchor --> captureButton.centerYAnchor
        openGalleryButton.widthAnchor --> Self.ACTION_BUTTON_BUTTON_SIZE
        openGalleryButton.heightAnchor --> Self.ACTION_BUTTON_BUTTON_SIZE
        openGalleryButton.addTarget(self, action: #selector(openGalleryAction), for: .touchUpInside)
    }
    
    func configureImagesPreview() {
       
        imagesPreview.autoresizingOff()
        view.addSubview(imagesPreview)
        imagePreviewHeightConstraint = imagesPreview.heightAnchor --> ImagesPreviewView.IMAGE_PREVIEW_HEIGHT
        imagesPreview.leadingAnchor --> view.leadingAnchor
        imagesPreview.trailingAnchor --> view.trailingAnchor
        imagesPreview.bottomAnchor --> captureButton.topAnchor + -Const.View.m16
       
    }
    
    private func configureDraggableImage() {
        dragView.autoresizingOff()
        dragImage.autoresizingOff()
        dragView.addSubview(dragImage)
        dragImage.heightAnchor --> 6
        dragImage.widthAnchor --> (Const.View.m16 * 2.5)
        dragImage.backgroundColor = UIColor.white
        dragImage.centerYAnchor --> dragView.centerYAnchor
        dragImage.centerXAnchor --> dragView.centerXAnchor
        dragImage.layer.cornerRadius = 3
        dragImage.smoothCornerCurve()
        view.addSubview(dragView)
        dragView.heightAnchor --> 30
        dragView.leadingAnchor --> view.leadingAnchor
        dragView.trailingAnchor --> view.trailingAnchor
        dragView.bottomAnchor --> imagesPreview.topAnchor + -6
        dragView.backgroundColor = .clear
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dragImagePreview(_:)))
        dragView.addGestureRecognizer(panGesture)
    }
    
    func configureOverlayView() {
//         TODO add a blurr effect here
        overlayView.autoresizingOff()
        overlayView.isHidden = true
        
        view.insertSubview(overlayView, aboveSubview: captureButton)
        overlayView --> view

        overlayLabel.autoresizingOff()
        overlayLabel.numberOfLines = 0
        overlayLabel.lineBreakMode = .byWordWrapping
        overlayLabel.textColor = Const.Color.labelColor
        overlayView.addSubview(overlayLabel)
        overlayLabel.centerYAnchor --> overlayView.centerYAnchor
        overlayLabel.centerXAnchor --> overlayView.centerXAnchor

        let tapGeature = UITapGestureRecognizer(target: self, action: #selector(didTapToResumeCamera))
        overlayView.addGestureRecognizer(tapGeature)
    }
    
    func requestSavePhotoAccess(completion: @escaping Completion<()>) {
        let okAction = UIAlertAction(title: AppStrings.CaptureStatus.alertOk, style: .cancel, handler: nil)

        PHPhotoLibrary.requestAuthorization { [self] status in
            switch status {
                case .authorized, .limited:
                    completion(())
                case .denied:
                  // we save the photo in temp directory
                    presentNotAuthorised(message: "")
                case .notDetermined, .restricted:
                    Logger.log(AppStrings.Error.CaptureStatus.notAuthOrDet)
                    presentAlert(title: AppStrings.CaptureStatus.alertTitle, message: AppStrings.CaptureStatus.configrationFailed, actions: okAction)
                @unknown default:
                    Logger.log(AppStrings.Error.CaptureStatus.unknown)
                    presentAlert(title: AppStrings.CaptureStatus.alertTitle, message: AppStrings.CaptureStatus.configrationFailed, actions: okAction)
            }
        }
    }
    
    private func presentNotAuthorised(message: String) {
        let okAction = UIAlertAction(title: AppStrings.CaptureStatus.alertOk, style: .cancel, handler: nil)
        let settingsAction = UIAlertAction(title: AppStrings.CaptureStatus.settings, style: .default, handler:{ _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,options: [:],completionHandler: nil)
            
        })
        presentAlert(title: AppStrings.CaptureStatus.alertTitle, message: message, actions: okAction, settingsAction)
    }
}

//
// MARK: - Private Session functions
//

private extension CaptureStatusViewController {
   
    func startCaptureSession() {
        sessionQueue.async {
            self.addObservers()
            self.captureSession.startRunning()
            self.isSessionRunning = self.captureSession.isRunning
        }
    }
    
    func stopCaptureSession() {
        captureSession.stopRunning()
        removeObservers()
    }
    
    func checkCameraPermission() {
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthStatus {
            case .authorized:
                return
            case .denied:
                presentToast(message: AppStrings.CaptureStatus.cameraAccessRequired)
            case .notDetermined:
                sessionQueue.suspend()
                AVCaptureDevice.requestAccess(for: .video) { authorised in
                    if !authorised {
                        // present alert here
                        Logger.log("Camera access is not authorised")
                        self.setupResult = .notAuthorized
                    }
                    self.sessionQueue.resume()
                }
            case .restricted:
                // present alert
                Logger.log("Camera access is restricted")
            @unknown default:
                Logger.log("unknown case")
                self.setupResult = .notAuthorized
        }
    }
    
    func configureCaptureSession() {
        sessionQueue.async { [self] in
            captureSession.beginConfiguration()
            if captureSession.canSetSessionPreset(.photo) {
                captureSession.sessionPreset = .photo
            }
            setupVideoInput()
            setupAudioInput()
            
            setupPhotoOutput()
            setupVideoOutput() // remove toggle video output
            captureSession.commitConfiguration()
        }
    }
    
    private func setupVideoInput() {
        do {
            // configure device
            var defaultVideoDevice: AVCaptureDevice?
            
            if let dualCameraDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) {
                defaultVideoDevice = dualCameraDevice
            } else if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                defaultVideoDevice = backCameraDevice
            } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                defaultVideoDevice = frontCameraDevice
            }
            
            
            guard let videoDevice = defaultVideoDevice else {
                Logger.log(AppStrings.Error.CaptureStatus.configrationFailed)
                setupResult = .configurationFailed
                captureSession.commitConfiguration()
                return
            }
            
            // connect input
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            
            if captureSession.canAddInput(videoDeviceInput) {
                captureSession.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            } else {
                Logger.log(AppStrings.Error.CaptureStatus.configrationFailed)
                setupResult = .configurationFailed
                captureSession.commitConfiguration()
                return
            }
        } catch {
            Logger.log(AppStrings.Error.CaptureStatus.configrationFailed)
            setupResult = .configurationFailed
            captureSession.commitConfiguration()
            return
        }
    }
    
    private func setupAudioInput() {
        do {
            guard let audioDevice = AVCaptureDevice.default(for: .audio) else { return }
            let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
            
            if captureSession.canAddInput(audioDeviceInput) {
                captureSession.addInput(audioDeviceInput)
            } else {
                Logger.log("Could not add audio device to the session")
            }
        } catch {
            Logger.log("Could not add audio device to the session \(error)")

        }
    }
    
    private func setupVideoOutput() {
        let movieFileOutput = AVCaptureMovieFileOutput()
        if self.captureSession.canAddOutput(movieFileOutput) {
            captureSession.beginConfiguration()
            captureSession.addOutput(movieFileOutput)
            captureSession.sessionPreset = .high
            
            if let connection = movieFileOutput.connection(with: .video) {
                if connection.isVideoStabilizationSupported {
                    connection.preferredVideoStabilizationMode = .auto
                }
            }
            captureSession.commitConfiguration()
            self.movieFileOutput = movieFileOutput
            if movieFileOutput.connections.first?.isVideoOrientationSupported == true {
                movieFileOutput.connections.first?.videoOrientation = .portrait
            }

        }
    }
    
    private func recordVideo() {
        
        guard let movieFileOutput = self.movieFileOutput else {
            return
        }
        
        sessionQueue.async { [self] in
            if !movieFileOutput.isRecording {
                
                if UIDevice.current.isMultitaskingSupported {
                    backgroundRecordingID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
                }
                
                let movieFileOutputConnection = movieFileOutput.connection(with: .video)
                movieFileOutputConnection?.videoOrientation = .portrait
                
                let availableVideoCodecTypes = movieFileOutput.availableVideoCodecTypes
                
                if availableVideoCodecTypes.contains(.hevc) {
                    movieFileOutput.setOutputSettings([AVVideoCodecKey: AVVideoCodecType.hevc], for: movieFileOutputConnection!)
                }
                
                let outputFileName = UUID().uuidString
                let outputFilePath =  (NSTemporaryDirectory() as NSString).appendingPathComponent((outputFileName as NSString).appendingPathExtension("mov")!)
                movieFileOutput.startRecording(to: URL(fileURLWithPath: outputFilePath), recordingDelegate: self)
            } else {
                movieFileOutput.stopRecording()
            }
        }
    }
    
    private func stopRecordingVideo() {
        guard let movieFileOutput = self.movieFileOutput else {
            return
        }
        movieFileOutput.stopRecording()
    }
    
    private func toggleCaptureMode() {
        if captureMode == .photo {
            sessionQueue.async { [self] in
                captureSession.beginConfiguration()
                captureSession.removeOutput(self.movieFileOutput)
                captureSession.sessionPreset = .photo
                
                self.movieFileOutput = nil
                
                self.captureSession.commitConfiguration()
            }
        } else {
            setupVideoOutput()
        }
    }
    
    private func setupPhotoOutput() {
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
            
            photoOutput.isHighResolutionCaptureEnabled = true
            photoOutput.isPortraitEffectsMatteDeliveryEnabled = photoOutput.isPortraitEffectsMatteDeliverySupported
            if #available(iOS 13.0, *) {
                photoOutput.maxPhotoQualityPrioritization = .quality
            }
        } else {
            Logger.log("cannot add photo output to session")
            setupResult = .configurationFailed
            captureSession.commitConfiguration()
            return
        }
    }
    
    private func switchCameraInput() {
        switchCameraButton.isEnabled = false
        captureButton.isEnabled = false
        sessionQueue.async { [self] in
            let currentVideoDevice = self.videoDeviceInput.device // crashes when there are no camera should guard against that and I switch
            let currentPosition = currentVideoDevice.position
            
            let preferedPosition: AVCaptureDevice.Position
            let preferedDeviceType: AVCaptureDevice.DeviceType
            
            switch currentPosition {
                case .unspecified, .front:
                    preferedPosition = .back
                    preferedDeviceType = .builtInDualCamera
                case .back:
                    preferedPosition = .front
                    preferedDeviceType = .builtInTrueDepthCamera
                @unknown default:
                    Logger.i("Unknown capture position. Defaulting to back, dual-camera.")
                    preferedPosition = .back
                    preferedDeviceType = .builtInDualCamera
            }
            
            let devices = self.videoDeviceDiscoverySession.devices
            var newVideoDevice: AVCaptureDevice? = nil
            
            if let device = devices.first(where: {$0.position == preferedPosition && $0.deviceType == preferedDeviceType}) {
                newVideoDevice = device
            } else if let device = devices.first(where: {$0.position == preferedPosition }) {
                newVideoDevice = device
            }
            
            if let videoDevice = newVideoDevice {
                do {
                    let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                    
                    captureSession.beginConfiguration()
                    captureSession.removeInput(self.videoDeviceInput)
                    
                    if captureSession.canAddInput(videoDeviceInput) {
                        NotificationCenter.default.removeObserver(self, name: .AVCaptureDeviceSubjectAreaDidChange, object: currentVideoDevice)
                        NotificationCenter.default.addObserver(self, selector: #selector(self.subjectAreaDidChange), name: .AVCaptureDeviceSubjectAreaDidChange, object: videoDeviceInput.device)
                        captureSession.addInput(videoDeviceInput)
                        self.videoDeviceInput = videoDeviceInput
                    } else {
                        captureSession.addInput(self.videoDeviceInput)
                    }
                    
                    if let connection = self.movieFileOutput?.connection(with: .video) {
                        if connection.isVideoStabilizationSupported {
                            connection.preferredVideoStabilizationMode = .auto
                        }
                    }
                   
                    captureSession.commitConfiguration()
                } catch {
                    Logger.log("Error occurred while creating video device input: \(error)")
                }
                
                DispatchQueue.main.async {
                    switchCameraButton.isEnabled = true
                    captureButton.isEnabled = true
                }
            }
        }
    }
    

    
    func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sessionWasInterrupted),
                                               name: .AVCaptureSessionWasInterrupted,
                                               object: captureSession)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sessionInterruptionEnded),
                                               name: .AVCaptureSessionInterruptionEnded,
                                               object: captureSession)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(sessionRuntimeError),
                                               name: .AVCaptureSessionRuntimeError,
                                               object: captureSession)
    }
    
    func removeObservers() {
        NotificationCenter.default.removeObserver(self)
    }

   
    
    private func flashScreen(completion: @escaping Completion<Bool>) {
        previewLayer.opacity = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.previewLayer.opacity = 1
        }, completion: completion)
    }
}

extension CaptureStatusViewController: AVCaptureFileOutputRecordingDelegate {
    // didStrat recording
    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        Logger.log("did start recording")
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
//        var success = true
        
        if error != nil {
            Logger.log("Movie file finishing error: \(String(describing: error))")
//            success = (((error! as NSError).userInfo[AVErrorRecordingSuccessfullyFinishedKey] as AnyObject).boolValue)!
        }
        
        coordinator.startTrimVideoViewController(navigationController: navigationController, videoURL: outputFileURL)
//        saveToPhotos(success, outputFileURL)
    }
    
    private func cleanup(outputFileURL: URL) {
        let path = outputFileURL.path
        if FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.removeItem(atPath: path)
            } catch {
                Logger.log("Could not remove file at URL: \(outputFileURL)")
            }
        }
        
        if let currentBackgroundRecordingID = backgroundRecordingID {
            backgroundRecordingID = UIBackgroundTaskIdentifier.invalid
            
            if currentBackgroundRecordingID != UIBackgroundTaskIdentifier.invalid {
                UIApplication.shared.endBackgroundTask(currentBackgroundRecordingID)
            }
        }
    }
    
    private func saveToPhotos(_ success: Bool, _ outputFileURL: URL) {
        if success {            
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    PHPhotoLibrary.shared().performChanges {
                        let options = PHAssetResourceCreationOptions()
//                        options.shouldMoveFile = true // will  clean up manually
                        let creationRequest = PHAssetCreationRequest.forAsset()
                        creationRequest.addResource(with: .video, fileURL: outputFileURL, options: options)
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
        } else {
            //            cleanup()
        }
    }
    
    
}

extension CaptureStatusViewController: ImagesPreviewViewDelegate {
    func didClickImage(_ photoAsset: [String: PHAsset]) {
        handleSelectedImageCompletion(photoAsset)
    }
}
