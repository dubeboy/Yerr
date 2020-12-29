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

class CaptureStatusViewController: UIViewController {
    
    // MARK: Session Management
    
    private enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }
    
    private enum captureMode {
        case photo, movie
    }

    var coordinator: PhotosGalleryCoordinator!
    
    private var captureButton = CaptureButton()
    private var openGalleryButton = UIImageView()
    
    private var captureSession = AVCaptureSession()
    
//    private var backCamera: AVCaptureDevice!
//    private var frontCamera: AVCaptureDevice!
//    private var backInput: AVCaptureInput!
//    private var frontInput: AVCaptureInput!
    
    private var inProgressPhotoCaptureDelegates = [Int64: PhotoCaptureProcessor]()
    
    @objc dynamic var videoDeviceInput: AVCaptureDeviceInput!
    
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var videoOutput: AVCaptureVideoDataOutput!
    private let photoOutput = AVCapturePhotoOutput()
    
    private var switchCameraButton: UIBarButtonItem!
     
    private var isBackCameraOn: Bool = true
    
    private let overlayView = UIView()
    private let overlayLabel = UILabel()
    
    private let sessionQueue = DispatchQueue(label: "session queue")
    private var isSessionRunning = false
    
    private var setupResult: SessionSetupResult = .success

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf()
        configureCaptureButton()
        configureOpenGalleryButton()
        configureOverlayView()
        setupPreviewLayer()
        configureCaptureSession()
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
    }

    @objc func switchCamera() {
        switchCameraInput()
    }
    
    @objc func takePictureAction() {
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
                
                    
            }, completionHandler: { photoProcessor in
                self.sessionQueue.async {
                    self.inProgressPhotoCaptureDelegates[photoProcessor.requestedPhotoSettings.uniqueID] = nil
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
    
    @objc func takeVideoAction(gestureReconizer: UILongPressGestureRecognizer) {
    }
    
    @objc func openGalleryAction() {
        coordinator.startPhotosGalleryViewController(navigationController: navigationController, completion: { _ in })
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // TODO: check SystemPressureState here to lower frame rate!!!
    
}

//
// MARK: Private helper functions
//

private extension CaptureStatusViewController {
    func configureSelf() {
        switchCameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(switchCamera))
        navigationItem.rightBarButtonItem = switchCameraButton
        addCloseButtonItem(toLeft: true)
    }
    
    func configureCaptureButton() {
        captureButton.autoresizingOff()
        view.addSubview(captureButton)
        captureButton.bottomAnchor --> view.bottomAnchor + -Const.View.m16 * 2
        captureButton.centerXAnchor --> view.centerXAnchor
        captureButton.widthAnchor --> 60
        captureButton.heightAnchor --> 60
        captureButton.addTarget(self, action: #selector(takePictureAction), for: .touchUpInside)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(takeVideoAction))
        longPressRecognizer.minimumPressDuration = 0.5
        longPressRecognizer.delaysTouchesBegan = true
        captureButton.addGestureRecognizer(longPressRecognizer)
        // add long press to rec
    }
    
    private func configureOpenGalleryButton() {
        openGalleryButton.autoresizingOff()
        view.addSubview(openGalleryButton)
        openGalleryButton.image = Const.Assets.CaptureStatus.openGalleryIcon?.withRenderingMode(.alwaysTemplate)
        openGalleryButton.tintColor = Const.Color.systemWhite
        openGalleryButton.leadingAnchor --> view.leadingAnchor + Const.View.m16
        openGalleryButton.centerYAnchor --> captureButton.centerYAnchor
        openGalleryButton.widthAnchor --> 40
        openGalleryButton.heightAnchor --> 40
        openGalleryButton.contentMode = .scaleAspectFit
        openGalleryButton.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openGalleryAction))
        openGalleryButton.addGestureRecognizer(tapGesture)
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
// MARK: Private Session functions
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
            setupOutput()
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

    func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.insertSublayer(previewLayer, below: captureButton.layer)
        previewLayer.frame = self.view.layer.frame
    }
    
    func setupOutput() {
        videoOutput = AVCaptureVideoDataOutput()
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            presentAlert(message: AppStrings.Error.genericError) { _ in }
            Logger.log(AppStrings.CaptureStatus.unableToAddVideoOutputToSession)
        }
        videoOutput.connections.first?.videoOrientation = .portrait
    }
    
    func switchCameraInput() {
//        switchCameraButton.isEnabled = false
//
//        captureSession.beginConfiguration()
//        if isBackCameraOn {
//            captureSession.removeInput(backInput)
//            captureSession.addInput(frontInput)
//            isBackCameraOn = false
//        } else {
//            captureSession.removeInput(frontInput)
//            captureSession.addInput(backInput)
//            isBackCameraOn = true
//        }
//
//        videoOutput.connections.first?.videoOrientation = .portrait
//        videoOutput.connections.first?.isVideoMirrored = !isBackCameraOn
//        captureSession.commitConfiguration()
//        switchCameraButton.isEnabled = true
    }
    
    private func flashScreen(completion: @escaping Completion<Bool>) {
        previewLayer.opacity = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.previewLayer.opacity = 1
        }, completion: completion)
    }
}
