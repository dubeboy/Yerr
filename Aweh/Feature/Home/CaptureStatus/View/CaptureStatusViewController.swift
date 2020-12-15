//
//  CaptureStatusViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/28.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit
import AVFoundation

//https://medium.com/@barbulescualex/making-a-custom-camera-in-ios-ea44e3087563

class CaptureStatusViewController: UIViewController {
    
    var coordinator: PhotosGalleryCoordinator!
    
    var captureButton = CaptureButton()
    var openGalleryButton = UIImageView()
    
    var captureSession: AVCaptureSession!
    
    var backCamera: AVCaptureDevice!
    var frontCamera: AVCaptureDevice!
    var backInput: AVCaptureInput!
    var frontInput: AVCaptureInput!
    
    var previewLayer: AVCaptureVideoPreviewLayer!
    var videoOutput: AVCaptureVideoDataOutput!
    
    var takePicture = false
    
    var switchCameraButton: UIBarButtonItem!
    
    var isBackCameraOn: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf()
        configureCaptureButton()
        configureOpenGalleryButton()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkCameraPermission()
        setupAndStartCaptureSession()
    }
    
    @objc func switchCamera() {
        switchCameraInput()
    }
    
    @objc func takePictureAction() {
        takePicture = true
    }
    
    @objc func openGalleryAction() {
        coordinator.startPhotosGalleryViewController(navigationController: navigationController, completion: { _ in })
    }
}

// MARK: private functions

private extension CaptureStatusViewController {
    func configureSelf() {
        switchCameraButton = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(switchCamera))
        navigationItem.rightBarButtonItem = switchCameraButton
    }
    
    func configureCaptureButton() {
        captureButton.autoresizingOff()
        view.addSubview(captureButton)
        captureButton.bottomAnchor --> view.bottomAnchor + -Const.View.m16 * 2
        captureButton.centerXAnchor --> view.centerXAnchor
        captureButton.widthAnchor --> 60
        captureButton.heightAnchor --> 60
        captureButton.addTarget(self, action: #selector(takePictureAction), for: .touchUpInside)
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
  
    func checkCameraPermission() {
        let cameraAuthStatus = AVCaptureDevice.authorizationStatus(for: .video)
        switch cameraAuthStatus {
            case .authorized:
                return
            case .denied:
                presentToast(message: AppStrings.CaptureStatus.cameraAccessRequired)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { authorised in
                    if !authorised {
                        // present alert here
                        Logger.log("Camera access is not authorised")
                    }
                }
            case .restricted:
                // present alert
                Logger.log("Camera access is restricted")
            @unknown default:
                Logger.log("unknown case")
        }
    }
    
    func setupAndStartCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async { [self] in
            self.captureSession = AVCaptureSession()
            self.captureSession.beginConfiguration()
            if captureSession.canSetSessionPreset(.photo) {
                captureSession.sessionPreset = .photo
            }
            captureSession.automaticallyConfiguresApplicationAudioSession = true
            setupInputs()
            
            DispatchQueue.main.async {
                // setup preview layer
                setupPreviewLayer()
            }
            
            setupOutput()
        
            //  do some config
            self.captureSession.commitConfiguration()
            self.captureSession.startRunning()
        }
    }
    
    func setupInputs() {
        // get camera input
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            backCamera = device
        } else {
            presentAlert(message: AppStrings.CaptureStatus.backCameraNotAvailable) {}
        }
        
        // get camera input
        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            frontCamera = device
        } else {
            presentAlert(message: AppStrings.CaptureStatus.frontCameraNotAvailable) {}
        }
        
        guard let bInput = try? AVCaptureDeviceInput(device: backCamera) else {
            presentAlert(message: AppStrings.Error.genericError) {}
            Logger.log(AppStrings.CaptureStatus.noInputDeviceForBackCamera)
            return
        }
        
        backInput = bInput
        
        if !captureSession.canAddInput(backInput) {
            presentAlert(message: AppStrings.Error.genericError) {}
            Logger.log(AppStrings.CaptureStatus.unableToAddBackCameraToSession)
        }
        
        guard let fInput = try? AVCaptureDeviceInput(device: frontCamera) else {
            presentAlert(message: AppStrings.Error.genericError) {}
            Logger.log(AppStrings.CaptureStatus.noInputDeviceForBackCamera)
            return
        }
        
        frontInput = fInput
        
        if !captureSession.canAddInput(frontInput) {
            presentAlert(message: AppStrings.Error.genericError) {}
            Logger.log(AppStrings.CaptureStatus.unableToAddFrontCameraToSession)
        }
        
        // connect back session
        captureSession.addInput(backInput)
        
    }
    
    func setupPreviewLayer() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.insertSublayer(previewLayer, below: captureButton.layer)
        previewLayer.frame = self.view.layer.frame
    }
    
    func setupOutput() {
        videoOutput = AVCaptureVideoDataOutput()
        let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
        videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        
        if captureSession.canAddOutput(videoOutput) {
            captureSession.addOutput(videoOutput)
        } else {
            presentAlert(message: AppStrings.Error.genericError) {}
            Logger.log(AppStrings.CaptureStatus.unableToAddVideoOutputToSession)
        }
        videoOutput.connections.first?.videoOrientation = .portrait
    }
    
    func switchCameraInput() {
        switchCameraButton.isEnabled = false
        
        captureSession.beginConfiguration()
        if isBackCameraOn {
            captureSession.removeInput(backInput)
            captureSession.addInput(frontInput)
            isBackCameraOn = false
        } else {
            captureSession.removeInput(frontInput)
            captureSession.addInput(backInput)
            isBackCameraOn = true
        }
        
        videoOutput.connections.first?.videoOrientation = .portrait
        videoOutput.connections.first?.isVideoMirrored = !isBackCameraOn
        captureSession.commitConfiguration()
        switchCameraButton.isEnabled = true
    }
}

extension CaptureStatusViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if !takePicture {
            return
        }
        takePicture = false
        
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        let uiImage = UIImage(ciImage: ciImage)
        
        DispatchQueue.main.async {
           // use the image here
            uiImage
            
        }
       
    }
}
