//
//  TrimVideoViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/28.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

// AVVideoCompositionCoreAnimationTool ::: a class that lets you combine an existing video with Core Animation layers.
// https://warrenmoore.net/understanding-cmtime // more about CMTIME
// Look into the cannot rec§ord error, I think it happens when we lauch the screen before we began recording!!!!
// https://www.raywenderlich.com/2734-avfoundation-tutorial-adding-overlays-and-animations-to-videos
// https://medium.com/@andy.nguyen.1993/add-overlay-image-to-video-21d9cc03c9eb
// https://github.com/inspace-io/VideoOverlayProcessor
// https://github.com/jiayilin/SafeWalk/blob/master/My_Camera_App/AVFoundation.framework/Headers/AVVideoComposition.h
// http://bradgayman.com/blog/recordingAView/index.html
// https://stackoverflow.com/questions/28813339/move-a-view-up-only-when-the-keyboard-covers-an-input-field?noredirect=1&lq=1
// https://stackoverflow.com/questions/49070965/colored-text-background-with-rounded-corners
// https://stackoverflow.com/questions/48088956/text-background-with-round-corner-like-instagram-does
// https://instagram-engineering.com/building-type-mode-for-stories-on-ios-and-android-8804e927feba
// https://stackoverflow.com/questions/16362407/nsattributedstring-background-color-and-rounded-corners?rq=1
class TrimVideoViewController: UIViewController {
    
    var presenter: TrimVideoViewPresenter!
    var coordinator: HomeCoordinator!
    
    // MARK: video display
    @LateInit
    private var rangeSliderView: TrimPostVideoRangeSliderView
    private let videoView: StatusVideoView = StatusVideoView()
    private let playVideoButton = YerrButton() // TODO: should add some materiels behind this view, translucent glass!!!
    
    
    // MARK: Video manipulation
    private let composition = AVMutableComposition()
    private var videoSize: CGSize = .zero
//    private var startTimeRange: CMTime = .zero // these should be in viewmodel
//    private var endTimeDuration: CMTime = .zero
    
    private let videoComposition = AVMutableVideoComposition()
    private let outputLayer = CALayer()
    @LateInit
    private var overlayView: UIView
    
    @LateInit
    private var asset: AVURLAsset // maybe this should go to the presenter!!!
    
    private var rangeSliderHeight: CGFloat = 40
    var firstTime = true
    
//    let progressIndicator // for when the asset need to be downloaded (selected from photos)
    
    private let videoTextEditorBackgroundView = UIView()
    private var overlayTextViews = [Int: UITextView]()
    private let overlayTextInput = UITextView()
    @LateInit
    private var videoTextEditorBottomAnchor: NSLayoutConstraint
    
    @LateInit
    private var actionsToolbar: TextViewActionsView
    @LateInit
    private var actionsToolbarBottomConstraint: NSLayoutConstraint

    override func viewDidLoad() {
        super.viewDidLoad()
        let rangeSliderWidth = view.frame.width - (Const.View.m16 * 4)
        rangeSliderView = TrimPostVideoRangeSliderView(frame: CGRect(origin: CGPoint(x: Const.View.m16 * 2, y: Const.View.m16 * 2), size: CGSize(width: rangeSliderWidth, height: rangeSliderHeight)))
        actionsToolbar = TextViewActionsView(delegate: self, colors: presenter.colors)
        asset = AVURLAsset(url: presenter.videoURL)
        videoSize = getVideoSize()
       
        
        configureSelf()
        configurePlayVideoButton()
        configureVideoView()
        configureActionsToolBar()
//        congfigureOverlayTextView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if firstTime {
            overlayView = UIView(frame: CGRect(origin: .zero, size: videoView.bounds.size))
            configureOverlayView()
            firstTime = false
        }
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        view.endEditing(true)
        super.viewWillAppear(animated)
        configureRangeSlider()
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
        actionsToolbarBottomConstraint.constant = -(Const.View.m16 + view.safeAreaInsets.bottom)

    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        guard let frame = keyboardFrame(from: notification) else { return }
//        videoTextEditorBottomAnchor.constant = -frame.size.height - Const.View.m16
        // use this to change the center of the text and then reset it back
        
        actionsToolbarBottomConstraint.constant = -frame.size.height
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        videoView.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        videoView.delegate = nil
        cleanup()
    }
    
    @objc private func addTextToVideo() {
        addOverlayTextView(color: .cyan)
    }
    
    @objc private func didTapPlayAction() {
        videoView.play()
    }
    
    @objc private func didTapVideoViewAction() {
        videoView.pause()
    }
    
    @objc private func didTapEndEditingAction() {
        view.endEditing(true)
    }
}

// MARK: - private functions

private extension TrimVideoViewController {
    private func configureSelf() {
//        rangeSliderView.autoresizingOff()
        videoView.autoresizingOff()
        videoView.delegate = self
        videoView.hideLabel()
        view.addSubview(videoView)
        videoView --> view
        videoView.addSubview(rangeSliderView)
    
        addCloseButtonItem(toLeft: true)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Export(Sent)", style: .plain, target: self, action: #selector(didTapSendAction)),
                                              UIBarButtonItem(title: "Add Text", style: .plain, target: self, action: #selector(addTextToVideo))]
    }
    
    private func configureRangeSlider() {
        rangeSliderView.setVideoURL(videoURL: presenter.videoURL)
        rangeSliderView.delegate = self
    }
    
    private func addOverlayTextView(color: UIColor) {
        let tag = presenter.appendEditableTextAndGetTag(text: " ")
        let overlayTextView = OverlayTextView(parent: view, backgroundColor: color, tag: tag)
        overlayTextView.addToParent() // TODO: needs fix
        overlayTextView.becomeFirstResponder()
    }
    
    private func doneEditingText() {
        overlayTextInput.text = ""
        videoTextEditorBackgroundView.isHidden = true
    }
    
    private func configureActionsToolBar() {
        actionsToolbar.autoresizingOff()
        view.addSubview(actionsToolbar)
        actionsToolbar.leadingAnchor --> view.leadingAnchor
        actionsToolbar.trailingAnchor --> view.trailingAnchor
        actionsToolbarBottomConstraint = actionsToolbar.bottomAnchor --> view.bottomAnchor + -(Const.View.m16 + view.safeAreaInsets.bottom)
    }
    
    @objc private func didTapSendAction() {
        exportAsset { [self] tmpURL in
            guard let outputFileURL = tmpURL else { return }
            presenter.postVideo(videoURL: outputFileURL, completion: {
//                coordinator.start
                self.dismiss(animated: true, completion: nil)
            }, failure: { errorString in
                presentToast(message: errorString)
            })
            
            PHPhotoLibrary.requestAuthorization { status in
                if status == .authorized {
                    PHPhotoLibrary.shared().performChanges {
                        let options = PHAssetResourceCreationOptions()
                        //                        options.shouldMoveFile = true // will  clean up manually
                        let creationRequest = PHAssetCreationRequest.forAsset()
                        creationRequest.addResource(with: .video, fileURL: outputFileURL, options: options)
                    } completionHandler: { (success, errror) in
                        if !success {
                            Logger.log("Could not save photo to you library \(String(describing: errror)) success: \(success) localized desc: \(String(describing: errror))")
                        } else {
                            Logger.log("saved video")
                        }
                        //                        cleanup()
                    }
                    
                }
                //                cleanup()
            }
        }
    }
    
    private func configurePlayVideoButton() {
        playVideoButton.autoresizingOff()
        videoView.insertSubview(playVideoButton, aboveSubview: rangeSliderView)
        let image = Const.Assets.TrimVideo.playVideoIcon?.withRenderingMode(.alwaysTemplate)
        playVideoButton.setImage(fillBoundsWith: image)
        playVideoButton.tintColor = Const.Color.TrimVideo.playVideo
        playVideoButton.widthAnchor --> 80
        playVideoButton.heightAnchor --> 80
        playVideoButton.centerYAnchor --> view.centerYAnchor + -22
        playVideoButton.centerXAnchor --> view.centerXAnchor
        playVideoButton.addTarget(self, action: #selector(didTapPlayAction), for: .touchUpInside)
    }
    
    private func configureVideoView() {
        videoView.setVideoPath(videoPath: presenter.videoURL.absoluteString)
        videoView.isUserInteractionEnabled = true
    }
    
    private func configureOverlayView() {
        videoView.insertSubview(overlayView, belowSubview: rangeSliderView)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapVideoViewAction))
        overlayView.isUserInteractionEnabled = true
        overlayView.addGestureRecognizer(tapGestureRecognizer)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapEndEditingAction))
        overlayView.addGestureRecognizer(tapGesture)
    }
    
//    // 1st iteration we add this!!§! so that we cater to the small phones
//    // secend we should be able to edit in screen!!!
//    private func congfigureOverlayTextView() {
//        videoTextEditorBackgroundView.autoresizingOff()
//        overlayTextInput.autoresizingOff()
//        videoView.addSubview(videoTextEditorBackgroundView)
//        videoTextEditorBackgroundView.topAnchor --> view.topAnchor + Const.View.m16
//        videoTextEditorBottomAnchor = videoTextEditorBackgroundView.bottomAnchor --> view.bottomAnchor + -Const.View.m16
//        videoTextEditorBackgroundView.leadingAnchor --> view.leadingAnchor + Const.View.m16
//        videoTextEditorBackgroundView.trailingAnchor --> view.trailingAnchor + -Const.View.m16
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapEndEditingAction))
//        videoTextEditorBackgroundView.addGestureRecognizer(tapGesture)
//
//        videoTextEditorBackgroundView.backgroundColor = Const.Color.TrimVideo.videoOverlayBackGround
//
//        videoTextEditorBackgroundView.addSubview(overlayTextInput)
//        overlayTextInput.textAlignment = .center
//        overlayTextInput.backgroundColor = .gray
//        overlayTextInput.centerYAnchor --> videoTextEditorBackgroundView.centerYAnchor
//        overlayTextInput.centerXAnchor --> videoTextEditorBackgroundView.centerXAnchor
//        overlayTextInput.trailingAnchor --> videoTextEditorBackgroundView.trailingAnchor + -Const.View.m16
//        overlayTextInput.leadingAnchor --> videoTextEditorBackgroundView.leadingAnchor + Const.View.m16
//        overlayTextInput.heightAnchor ->= 50
//        overlayTextInput.isScrollEnabled = false // Allows automatic height adjustment
////        overlayTextInput.contentInset = .equalEdgeInsets(Const.View.m16)
//
//        overlayTextInput.sizeToFit()
//
//        // add delegate and listen to content size changes if its >= to videoTextEditorBackgroundView then add top| bottom constrains
//        // and enable scrolling and if it exceed a certain number of chars it automatically goes to the bottom of screen like whatsapp
//
//    }
   
    // TODO: remove video from temp
    private func cleanup() {
        
    }

}

// MARK: - private functions for video composion and export

extension TrimVideoViewController {
    
    private func orientation(from transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) { // TODO: should just return
        return (UIImage.Orientation.up, true)
    }
    
    private func compositionLayerInstruction(for track: AVCompositionTrack, assetTrack: AVAssetTrack) -> AVMutableVideoCompositionLayerInstruction {
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let transform = assetTrack.preferredTransform
        
        instruction.setTransform(transform, at: .zero)
        
        return instruction
    }
    
    private func getVideoSize() -> CGSize {
        guard let assetTrack  = asset.tracks(withMediaType: .video).first else { return .zero }
        return CGSize(width: assetTrack.naturalSize.height, height: assetTrack.naturalSize.width)
    }
    
    private func setupVideoOverlayAndExportLayers() {
        // extract video from asset and add it to track
        guard
            let compositionTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid),
            let assetTrack  = asset.tracks(withMediaType: .video).first
        else {
            Logger.log(AppStrings.Error.TrimVideo.createCompositionalTrackFailed)
            presentToast(message: AppStrings.TrimVideo.createCompositionalTrackFailed)
            return
        }
        
        do {
            // the time range will also depend on the edited video!!!!
            let timeRange = CMTimeRange(start: .zero, duration: asset.duration)
            try compositionTrack.insertTimeRange(timeRange, of: assetTrack, at: .zero)
            
            if let audioAssetTrack = asset.tracks(withMediaType: .audio).first,
               let compositionalAudioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID:  kCMPersistentTrackID_Invalid) {
                try compositionalAudioTrack.insertTimeRange(timeRange, of: audioAssetTrack, at: .zero)
            }
        } catch {
            Logger.log(error)
            return
        }
        
        compositionTrack.preferredTransform = assetTrack.preferredTransform
        let videoInfo = orientation(from: assetTrack.preferredTransform)
        
        Logger.i("Is video portrait: \(videoInfo.isPortrait) and video ifno is \(videoInfo)")
        // set video size
        if videoInfo.isPortrait { // if portraint you need to reverse the width and height
            videoSize = CGSize(width: assetTrack.naturalSize.height, height: assetTrack.naturalSize.width)
        } else {
            videoSize = assetTrack.naturalSize
        }
        
        let backgroundLayer = CALayer() // TODO: this sould be equal to the view bounds!!!
        backgroundLayer.frame = CGRect(origin: .zero, size: videoSize)
        let videoLayer = CALayer()
        videoLayer.frame = CGRect(origin: .zero, size: videoSize)
        //        backgroundLayer.backgroundColor = UIColor(named: "rw-green")?.cgColor
        //        videoLayer.frame = CGRect(
        //            x: 20,
        //            y: 20,
        //            width: videoSize.width - 40,
        //            height: videoSize.height - 40)
        //        add visual effects to the video
        //        backgroundLayer.contents = UIImage(named: "background")?.cgImage
        //        backgroundLayer.contentsGravity = .resizeAspectFill
        
        let overlayLayer = CALayer()
        overlayLayer.frame = CGRect(origin: .zero, size: videoSize)
        //        addImages(to: overlayLayer, videoSize: videoSize)
//        add(text: "Hello therer", to: overlayLayer, videoSize: videoSize)
        overlayView.layer.sublayers?.reverse() // put them the way they where added
        if let overlayLayers = overlayView.layer.sublayers {
            for layer in overlayLayers {
                layer.removeFromSuperlayer()
                let frame = layer.convert(layer.frame, to: overlayLayer)
                layer.frame = CGRect(x: frame.origin.y, y: frame.origin.x , width: frame.size.width, height: frame.size.width)
//                layer.transform = CATransform3DMakeScale(UIScreen.main.scale, UIScreen.main.scale, 1)
                overlayLayer.addSublayer(layer)
                
            }
        }
        
        outputLayer.frame = CGRect(origin: .zero, size: videoSize)
        outputLayer.addSublayer(backgroundLayer)
        outputLayer.addSublayer(videoLayer)
        outputLayer.addSublayer(overlayLayer)
        
        
        videoComposition.renderSize = videoSize
        videoComposition.frameDuration = CMTime(value: 1, timescale: 30) // fps = 30
        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer
                                                                             , in: outputLayer)
        
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRange(start: .zero, duration: composition.duration)
        videoComposition.instructions = [instruction]
        
        let layerInstruction = compositionLayerInstruction(for: compositionTrack, assetTrack: assetTrack)
        instruction.layerInstructions = [layerInstruction]
        
        
    }
    
    private func exportAsset(completion: @escaping Completion<URL?>) {
        setupVideoOverlayAndExportLayers()
        
        guard let export = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        else {
            Logger.log(AppStrings.Error.TrimVideo.exportFailed)
            completion(nil)
            return
        }
        
        let videoName = UUID().uuidString
        let exportURL = URL(fileURLWithPath: NSTemporaryDirectory())
            .appendingPathComponent(videoName)
            .appendingPathExtension("mov")
        
        export.videoComposition = videoComposition
        export.shouldOptimizeForNetworkUse = true
        export.outputFileType = .mov
        export.outputURL = exportURL
        
        export.exportAsynchronously {
            DispatchQueue.main.async {
                switch export.status {
                    case .completed:
                        completion(exportURL)
                    default:
                        Logger.log("\(AppStrings.Error.TrimVideo.exportFailed) -- error --  \(export.error?.localizedDescription ?? "")")
                        completion(nil)
                        break
                }
            }
        }
    }
    
    
    private func addImages(to layer: CALayer, videoSize: CGSize) {
        let image = UIImage(named: "1")!
        let imageLayer = CALayer()
        
        let aspect: CGFloat = image.size.width / image.size.height
        let width = videoSize.width
        let height = width / aspect
        
        imageLayer.frame = CGRect(x: 0, y: -height * 0.5, width: width, height: height)
        imageLayer.contents = image.cgImage
        layer.addSublayer(imageLayer)
    }
    
    // instead of UITextView use this please!
    private func add(text: String, to layer: CALayer, videoSize: CGSize) {
        let attributedText = NSAttributedString(string: text,  attributes: [
                                                    .font: UIFont(name: "ArialRoundedMTBold", size: 60) as Any,
                                                    .foregroundColor: UIColor(named: "rw-green")!,
                                                    .strokeColor: UIColor.white,
                                                    .strokeWidth: -3])
        
        let textLayer = CATextLayer()
        textLayer.string = attributedText
        textLayer.shouldRasterize = true
        textLayer.rasterizationScale = UIScreen.main.scale
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = .center
        textLayer.frame = CGRect(x: 0, y: videoSize.height * 0.66, width: videoSize.width, height: 150)
        textLayer.displayIfNeeded() // This is becuase UIView can async sometimes
        layer.addSublayer(textLayer)
    }
}

extension TrimVideoViewController: TimePostVideoRangeSliderDelegate {
    func didChangeValue(videoRangeSlider: TrimPostVideoRangeSliderView, startTime: Float64, endTime: Float64) {
        Logger.i("start time \(startTime)")
        Logger.i("end time \(endTime)")
        
        presenter.startTime = startTime
        presenter.startTime = endTime
        
        videoView.endTIme = endTime
        videoView.startTime = startTime
        
        // play video!!!
        playVideoButton.isHidden = true
        videoView.play(shouldNotify: false)
    }

    func indicatorDidChangePosition(videoRangeSlider: TrimPostVideoRangeSliderView, position: Float64) {
        
    }

    func sliderGestureBegan() {
        Logger.i("sliderGestureBegan")
    }

    func sliderGestureEnded() {
        Logger.i("sliderGestureEnded")
    }
}

extension TrimVideoViewController: StatusVideoViewDelegate {
    func currentlyPlaying(seconds: Double) {
//        Logger.i("currentlyPlaying. seconds:  \(seconds)")
    }
    
    func didStartPlayingVideo() {
        UIView.animate(withDuration: 0.25) { [self] in
            playVideoButton.isHidden = true
        }
    }
    
    func didFinishPlayingVideo() {
        UIView.animate(withDuration: 0.25) { [self] in
            playVideoButton.isHidden = false
        }
    }
}

extension TrimVideoViewController: TextViewActionsViewDelegate {
    func didTapTextAlignment(alignment: PostStatusViewModel.TextAlignment) {
        let overlayTextView = getFirstResponsderTextView()
        switch alignment {
            case .center:
                overlayTextView?.textAlignment = .center
            case .left:
                overlayTextView?.textAlignment = .left
            case .right:
                overlayTextView?.textAlignment = .right
        }
    }
    
    func didTapColorToChange(tag: Int) {
        let overlayTextView = getFirstResponsderTextView()
        overlayTextView?.backgroundColor = UIColor(hex: presenter.colors[tag])
    }
    
    func didTapBoldText(textWeight: PostStatusViewModel.TextWeight) {
        let overlayTextView = getFirstResponsderTextView()
        switch textWeight {
            case .bold:
                overlayTextView?.font = UIFont.boldSystemFont(ofSize: 16) // TODO: get these values from Const
            case .italic:
                
                overlayTextView?.font = UIFont.italicSystemFont(ofSize: 16)
                
            case .normal:
                overlayTextView?.font = UIFont.systemFont(ofSize: 16)
        }
    }
    
    func didTapDoneActionButton() {
        view.endEditing(true)
    }
    
    private func getFirstResponsderTextView() -> OverlayTextView? {
        guard let textView = view.firstResponder as? OverlayTextView else { return nil }
        return textView
    }

}
