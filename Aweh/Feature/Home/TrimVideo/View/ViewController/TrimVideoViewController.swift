//
//  TrimVideoViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/28.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit
import AVFoundation

//AVVideoCompositionCoreAnimationTool ::: a class that lets you combine an existing video with Core Animation layers.
//https://warrenmoore.net/understanding-cmtime // more about CMTIME
// Look into the cannot record error, I think it happens when we lauch the screen before we began recording!!!!
class TrimVideoViewController: UIViewController {
    
    var presenter: TrimVideoViewPresenter!
    var coordinator: HomeCoordinator!
    
    // MARK: video display
    @LateInit
    private var rangeSliderView: TrimPostVideoRangeSliderView
    private var videoView: StatusVideoView = StatusVideoView()
    private let playVideoButton = YerrButton() // TODO: should add some materiels behind this view, translucent glass!!!
    
    
    // MARK: Video manipulation
    private let composition = AVMutableComposition()
    private var videoSize: CGSize = .zero
//    private var startTimeRange: CMTime = .zero // these should be in viewmodel
//    private var endTimeDuration: CMTime = .zero
    
    private let videoComposition = AVMutableVideoComposition()
    private let outputLayer = CALayer()
    
    @LateInit
    private var asset: AVURLAsset
    
    private var rangeSliderHeight: CGFloat = 40
    
//    let progressIndicator // for when the asset need to be downloaded (selected from photos)
    
    private let videoTextEditorBackgroundView = UIView()
    private var overlayTextViews = [Int: UITextView]()
    private let overlayTextInput = UITextView()
    @LateInit
    private var videoTextEditorBottomAnchor: NSLayoutConstraint

    override func viewDidLoad() {
        super.viewDidLoad()
        let rangeSliderWidth = view.frame.width - (Const.View.m16 * 4)
        rangeSliderView = TrimPostVideoRangeSliderView(frame: CGRect(origin: CGPoint(x: Const.View.m16 * 2, y: Const.View.m16 * 2), size: CGSize(width: rangeSliderWidth, height: rangeSliderHeight)))
        rangeSliderView.center.x = view.center.x
        asset = AVURLAsset(url: presenter.videoURL)
        configureSelf()
        configurePlayVideoButton()
        configureVideoView()
//        congfigureOverlayTextView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    @objc private func didMoveOverlayTextView(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        guard let overlayTextView = recognizer.view as? UITextView else { return }
            Logger.i("PAN state began changed ")
            overlayTextView.center = CGPoint(x: overlayTextView.center.x + translation.x, y: overlayTextView.center.y + translation.y)
            recognizer.setTranslation(.zero, in: view)

    
    }
    
    @objc private func didRotateOverlayTextView(recognizer: UIRotationGestureRecognizer) {
        Logger.i("ROT: state began ")
        let rotation = recognizer.rotation
        guard let overlayTextView = recognizer.view as? UITextView else { return }
        overlayTextView.transform = overlayTextView.transform.rotated(by: rotation)
        recognizer.rotation = 0
       
    }
    
    @objc func  didPichOverlayTextView(recognizer: UIPinchGestureRecognizer) {
        Logger.i("Pinch: state began ")
        let scale = recognizer.scale
        guard let overlayTextView = recognizer.view as? UITextView else { return }

        let currentTransform = overlayTextView.transform
        overlayTextView.transform = currentTransform.scaledBy(x: scale, y: scale)
        recognizer.scale = 1.0
    }
}

// MARK: private functions

private extension TrimVideoViewController {
    private func configureSelf() {
//        rangeSliderView.autoresizingOff()
        videoView.autoresizingOff()
        videoView.delegate = self
        videoView.hideLabel()
        view.addSubview(videoView)
        videoView --> view
        view.addSubview(rangeSliderView)
    
        addCloseButtonItem(toLeft: true)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Add Text", style: .plain, target: self, action: #selector(addTextToVideo))]
    }
    
    private func configureRangeSlider() {
        rangeSliderView.setVideoURL(videoURL: presenter.videoURL)
        rangeSliderView.delegate = self
//        rangeSliderView.maxSpace = 60.0
//        
//        rangeSliderView.setStartPosition(seconds: 50.0)
//        rangeSliderView.setEndPosition(seconds: 150)

    }
    
    private func addOverlayTextView(color: UIColor) {
        let tag = presenter.appendEditableTextAndGetTag(text: overlayTextInput.text)
        let overlayTextView = UITextView() // set frame rather!!
        overlayTextView.autoresizingOff()
        overlayTextView.backgroundColor = color.withAlphaComponent(0.6)
        overlayTextView.isScrollEnabled = false
        overlayTextView.tag = tag
        overlayTextView.textAlignment = .center
        overlayTextView.sizeToFit()
        overlayTextViews[tag] = overlayTextView
        overlayTextView.addShadow()
        overlayTextView.layer.cornerRadius = Const.View.radius
        let blurEffect = UIBlurEffect(style: .prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingOff()
        overlayTextView.addSubview(blurEffectView)
        overlayTextView.sendSubviewToBack(blurEffectView)
                
        view.addSubview(overlayTextView)
        overlayTextView.centerXAnchor --> view.centerXAnchor
        overlayTextView.centerYAnchor --> view.centerYAnchor
//        overlayTextView.center = view.center
        
        
        // also add the capability to add font here!!!!
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didMoveOverlayTextView(recognizer:)))
        overlayTextView.addGestureRecognizer(panGesture)
        let rotationGesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotateOverlayTextView(recognizer:)))
        overlayTextView.addGestureRecognizer(rotationGesture)
        let pinchGesture = UIPinchGestureRecognizer(target: self , action: #selector(didPichOverlayTextView(recognizer:)))
        overlayTextView.addGestureRecognizer(pinchGesture)
        
        panGesture.delegate = self
        rotationGesture.delegate = self
        pinchGesture.delegate = self
        
        
        overlayTextView.becomeFirstResponder()
    }
    
    private func doneEditingText() {
        overlayTextInput.text = ""
        videoTextEditorBackgroundView.isHidden = true
    }
    
    private func configurePlayVideoButton() {
        playVideoButton.autoresizingOff()
        view.addSubview(playVideoButton)
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
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapVideoViewAction))
        videoView.isUserInteractionEnabled = true
        videoView.addGestureRecognizer(tapGestureRecognizer)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapEndEditingAction))
        videoView.addGestureRecognizer(tapGesture)
    }
    
    // 1st iteration we add this!!§! so that we cater to the small phones
    // secend we should be able to edit in screen!!!
    private func congfigureOverlayTextView() {
        videoTextEditorBackgroundView.autoresizingOff()
        overlayTextInput.autoresizingOff()
        view.addSubview(videoTextEditorBackgroundView)
        videoTextEditorBackgroundView.topAnchor --> view.topAnchor + Const.View.m16
        videoTextEditorBottomAnchor = videoTextEditorBackgroundView.bottomAnchor --> view.bottomAnchor + -Const.View.m16
        videoTextEditorBackgroundView.leadingAnchor --> view.leadingAnchor + Const.View.m16
        videoTextEditorBackgroundView.trailingAnchor --> view.trailingAnchor + -Const.View.m16
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapEndEditingAction))
        videoTextEditorBackgroundView.addGestureRecognizer(tapGesture)

        videoTextEditorBackgroundView.backgroundColor = Const.Color.TrimVideo.videoOverlayBackGround
       
        videoTextEditorBackgroundView.addSubview(overlayTextInput)
        overlayTextInput.textAlignment = .center
        overlayTextInput.backgroundColor = .gray
        overlayTextInput.centerYAnchor --> videoTextEditorBackgroundView.centerYAnchor
        overlayTextInput.centerXAnchor --> videoTextEditorBackgroundView.centerXAnchor
        overlayTextInput.trailingAnchor --> videoTextEditorBackgroundView.trailingAnchor + -Const.View.m16
        overlayTextInput.leadingAnchor --> videoTextEditorBackgroundView.leadingAnchor + Const.View.m16
        overlayTextInput.heightAnchor ->= 50
        overlayTextInput.isScrollEnabled = false // Allows automatic height adjustment
//        overlayTextInput.contentInset = .equalEdgeInsets(Const.View.m16)
        
        overlayTextInput.sizeToFit()
        
        // add delegate and listen to content size changes if its >= to videoTextEditorBackgroundView then add top| bottom constrains
        // and enable scrolling and if it exceed a certain number of chars it automatically goes to the bottom of screen like whatsapp

    }
   
    // TODO: remove video from temp
    private func cleanup() {
        
    }

}

// MARK: private functions for video export

extension TrimVideoViewController {
    
    private func orientation(from transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
        var assetOrientation = UIImage.Orientation.up
        var isPortrait = false
        if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
            assetOrientation = .right
            isPortrait = true
        } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
            assetOrientation = .left
            isPortrait = true
        } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
            assetOrientation = .up
        } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
            assetOrientation = .down
        }
        
        return (assetOrientation, isPortrait)
    }
    
    // TODO: remove
    private func addConfetti(to layer: CALayer) {
        let images: [UIImage] = (0...5).map { UIImage(named: "confetti\($0)")! }
        let colors: [UIColor] = [.systemGreen, .systemRed, .systemBlue, .systemPink, .systemOrange, .systemPurple, .systemYellow]
        let cells: [CAEmitterCell] = (0...16).map { i in
            let cell = CAEmitterCell()
            cell.contents = images.randomElement()?.cgImage
            cell.birthRate = 3
            cell.lifetime = 12
            cell.lifetimeRange = 0
            cell.velocity = CGFloat.random(in: 100...200)
            cell.velocityRange = 0
            cell.emissionLongitude = 0
            cell.emissionRange = 0.8
            cell.spin = 4
            cell.color = colors.randomElement()?.cgColor
            cell.scale = CGFloat.random(in: 0.2...0.8)
            return cell
        }
        
        let emitter = CAEmitterLayer()
        emitter.emitterPosition = CGPoint(x: layer.frame.size.width / 2, y: layer.frame.size.height + 5)
        emitter.emitterShape = .line
        emitter.emitterSize = CGSize(width: layer.frame.size.width, height: 2)
        emitter.emitterCells = cells
        
        layer.addSublayer(emitter)
    }
    
    private func compositionLayerInstruction(for track: AVCompositionTrack, assetTrack: AVAssetTrack) -> AVMutableVideoCompositionLayerInstruction {
        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
        let transform = assetTrack.preferredTransform
        
        instruction.setTransform(transform, at: .zero)
        
        return instruction
    }
    
    private func makeEditableVideoView(fromVideoAt videoURL: URL) {
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
        add(text: "Hello therer", to: overlayLayer, videoSize: videoSize)
        
        
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
        textLayer.displayIfNeeded()
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

extension TrimVideoViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
