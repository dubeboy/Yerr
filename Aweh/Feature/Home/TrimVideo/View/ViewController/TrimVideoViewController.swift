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

class TrimVideoViewController: UIViewController {
    
    var presenter: TrimVideoViewPresenter!
    var coordinator: HomeCoordinator!
    
    // MARK: video display
    private var rangeSliderView: TrimPostVideoRangeSliderView = TrimPostVideoRangeSliderView()
    private var videoView: StatusVideoView = StatusVideoView()
    
    // MARK: Video manipulation
    private let composition = AVMutableComposition()
    private var videoSize: CGSize = .zero
//    private var startTimeRange: CMTime = .zero // these should be in viewmodel
//    private var endTimeDuration: CMTime = .zero
    
    let videoComposition = AVMutableVideoComposition()
    let outputLayer = CALayer()
    
    @LateInit
    private var asset: AVURLAsset
    
//    let progressIndicator // for when the asset need to be downloaded (selected from photos)

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getVideoURLAsUrlObject { url in
            asset = AVURLAsset(url: url)
        } failure: {
            presentToast(message: AppStrings.TrimVideo.assetNotFound)
            return
        }
        configureSelf()
    }
    
    @objc private func addTextToVideo() {
        
    }
}

// MARK: private functions

private extension TrimVideoViewController {
    private func configureSelf() {
        rangeSliderView.autoresizingOff()
        videoView.autoresizingOff()
        
        videoView.hideLabel()
        view.addSubview(videoView)
        videoView --> view
        view.addSubview(rangeSliderView)
        
        rangeSliderView.leadingAnchor --> view.leadingAnchor + Const.View.m16
        rangeSliderView.trailingAnchor --> view.trailingAnchor + -Const.View.m16
        rangeSliderView.bottomAnchor --> view.bottomAnchor + -Const.View.m16 * 2
        addCloseButtonItem(toLeft: true)
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "T", style: .plain, target: self, action: #selector(addTextToVideo))]
    }
    
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
        
    }
    
    func indicatorDidChangePosition(videoRangeSlider: TrimPostVideoRangeSliderView, position: Float64) {
        
    }
    
    func sliderGestureBegan() {
        
    }
    
    func sliderGestureEnded() {
        
    }
}