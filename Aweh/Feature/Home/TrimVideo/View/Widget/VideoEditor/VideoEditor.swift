//
//  VideoEditor.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/12/12.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

//https://www.raywenderlich.com/6236502-avfoundation-tutorial-adding-overlays-and-animations-to-videos

//class VideoEditor {
//    private func orientation(from transform: CGAffineTransform) -> (orientation: UIImage.Orientation, isPortrait: Bool) {
//        var assetOrientation = UIImage.Orientation.up
//        var isPortrait = false
//        if transform.a == 0 && transform.b == 1.0 && transform.c == -1.0 && transform.d == 0 {
//            assetOrientation = .right
//            isPortrait = true
//        } else if transform.a == 0 && transform.b == -1.0 && transform.c == 1.0 && transform.d == 0 {
//            assetOrientation = .left
//            isPortrait = true
//        } else if transform.a == 1.0 && transform.b == 0 && transform.c == 0 && transform.d == 1.0 {
//            assetOrientation = .up
//        } else if transform.a == -1.0 && transform.b == 0 && transform.c == 0 && transform.d == -1.0 {
//            assetOrientation = .down
//        }
//
//        return (assetOrientation, isPortrait)
//    }
//
//    private func addConfetti(to layer: CALayer) {
//        let images: [UIImage] = (0...5).map { UIImage(named: "confetti\($0)")! }
//        let colors: [UIColor] = [.systemGreen, .systemRed, .systemBlue, .systemPink, .systemOrange, .systemPurple, .systemYellow]
//        let cells: [CAEmitterCell] = (0...16).map { i in
//            let cell = CAEmitterCell()
//            cell.contents = images.randomElement()?.cgImage
//            cell.birthRate = 3
//            cell.lifetime = 12
//            cell.lifetimeRange = 0
//            cell.velocity = CGFloat.random(in: 100...200)
//            cell.velocityRange = 0
//            cell.emissionLongitude = 0
//            cell.emissionRange = 0.8
//            cell.spin = 4
//            cell.color = colors.randomElement()?.cgColor
//            cell.scale = CGFloat.random(in: 0.2...0.8)
//            return cell
//        }
//
//        let emitter = CAEmitterLayer()
//        emitter.emitterPosition = CGPoint(x: layer.frame.size.width / 2, y: layer.frame.size.height + 5)
//        emitter.emitterShape = .line
//        emitter.emitterSize = CGSize(width: layer.frame.size.width, height: 2)
//        emitter.emitterCells = cells
//
//        layer.addSublayer(emitter)
//    }
//
//    private func compositionLayerInstruction(for track: AVCompositionTrack, assetTrack: AVAssetTrack) -> AVMutableVideoCompositionLayerInstruction {
//        let instruction = AVMutableVideoCompositionLayerInstruction(assetTrack: track)
//        let transform = assetTrack.preferredTransform
//
//        instruction.setTransform(transform, at: .zero)
//
//        return instruction
//    }
//
//    private func makeEditableVideoView(fromVideoAt videoURL: URL, forName name: String, completion: @escaping (URL?) -> Void) {
//        let asset = AVURLAsset(url: videoURL)
//        let composition = AVMutableComposition()
//
//        guard
//            let compositionTrack = composition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid),
//            let assetTrack  = asset.tracks(withMediaType: .video).first
//        else {
//            Logger.log(AppStrings.Error.TrimVideo.createCompositionalTrackFailed)
//           completion(nil)
//            return
//        }
//
//        do {
//            // the time range will also depend on the edited video!!!!
//            let timeRange = CMTimeRange(start: .zero, duration: asset.duration)
//            try compositionTrack.insertTimeRange(timeRange, of: assetTrack, at: .zero)
//
//            if let audioAssetTrack = asset.tracks(withMediaType: .audio).first,
//               let compositionalAudioTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID:  kCMPersistentTrackID_Invalid) {
//                try compositionalAudioTrack.insertTimeRange(timeRange, of: audioAssetTrack, at: .zero)
//            }
//        } catch {
//            Logger.log(error)
//            return
//        }
//
//        compositionTrack.preferredTransform = assetTrack.preferredTransform
//        let videoInfo = orientation(from: assetTrack.preferredTransform)
//
//
//        let videoSize: CGSize
//        if videoInfo.isPortrait { // if portraint you need to reverse the width and height
//            videoSize = CGSize(width: assetTrack.naturalSize.height, height: assetTrack.naturalSize.width)
//        } else {
//            videoSize = assetTrack.naturalSize
//        }
//
//        let backgroundLayer = CALayer()
//        backgroundLayer.frame = CGRect(origin: .zero, size: videoSize)
//        let videoLayer = CALayer()
//        videoLayer.frame = CGRect(origin: .zero, size: videoSize)
////        backgroundLayer.backgroundColor = UIColor(named: "rw-green")?.cgColor
////        videoLayer.frame = CGRect(
////            x: 20,
////            y: 20,
////            width: videoSize.width - 40,
////            height: videoSize.height - 40)
//
////        add visual effects to the video
////        backgroundLayer.contents = UIImage(named: "background")?.cgImage
////        backgroundLayer.contentsGravity = .resizeAspectFill
//
//        let overlayLayer = CALayer()
//        overlayLayer.frame = CGRect(origin: .zero, size: videoSize)
////        addImages(to: overlayLayer, videoSize: videoSize)
//        add(text: "Hello therer", to: overlayLayer, videoSize: videoSize)
//
//        let outputLayer = CALayer()
//        outputLayer.frame = CGRect(origin: .zero, size: videoSize)
//        outputLayer.addSublayer(backgroundLayer)
//        outputLayer.addSublayer(videoLayer)
//        outputLayer.addSublayer(overlayLayer)
//
//        let videoComposition = AVMutableVideoComposition()
//        videoComposition.renderSize = videoSize
//        videoComposition.frameDuration = CMTime(value: 1, timescale: 30)
//        videoComposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videoLayer
//                                                                             , in: outputLayer)
//
//        let instruction = AVMutableVideoCompositionInstruction()
//        instruction.timeRange = CMTimeRange(start: .zero, duration: composition.duration)
//        videoComposition.instructions = [instruction]
//
//        let layerInstruction = compositionLayerInstruction(for: compositionTrack, assetTrack: assetTrack)
//        instruction.layerInstructions = [layerInstruction]
//
//        // here we export the video
//
//        guard let export = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
//        else {
//            Logger.log(AppStrings.Error.TrimVideo.exportFailed)
//            completion(nil)
//            return
//        }
//
//        let videoName = UUID().uuidString
//        let exportURL = URL(fileURLWithPath: NSTemporaryDirectory())
//            .appendingPathComponent(videoName)
//            .appendingPathExtension("mov")
//
//        export.videoComposition = videoComposition
//        export.outputFileType = .mov
//        export.outputURL = exportURL
//
//        export.exportAsynchronously {
//            DispatchQueue.main.async {
//                switch export.status {
//                    case .completed:
//                        completion(exportURL)
//                    default:
//                        Logger.log("\(AppStrings.Error.TrimVideo.exportFailed) -- error --  \(export.error?.localizedDescription ?? "")")
//                        completion(nil)
//                        break
//                }
//            }
//        }
//    }
//
//    private func addImages(to layer: CALayer, videoSize: CGSize) {
//        let image = UIImage(named: "1")!
//        let imageLayer = CALayer()
//
//        let aspect: CGFloat = image.size.width / image.size.height
//        let width = videoSize.width
//        let height = width / aspect
//
//        imageLayer.frame = CGRect(x: 0, y: -height * 0.5, width: width, height: height)
//        imageLayer.contents = image.cgImage
//        layer.addSublayer(imageLayer)
//    }
//
//    private func add(text: String, to layer: CALayer, videoSize: CGSize) {
//        let attributedText = NSAttributedString(string: text,  attributes: [
//                                                    .font: UIFont(name: "ArialRoundedMTBold", size: 60) as Any,
//                                                    .foregroundColor: UIColor(named: "rw-green")!,
//                                                    .strokeColor: UIColor.white,
//                                                    .strokeWidth: -3])
//
//        let textLayer = CATextLayer()
//        textLayer.string = attributedText
//        textLayer.shouldRasterize = true
//        textLayer.rasterizationScale = UIScreen.main.scale
//        textLayer.backgroundColor = UIColor.clear.cgColor
//        textLayer.alignmentMode = .center
//        textLayer.frame = CGRect(x: 0, y: videoSize.height * 0.66, width: videoSize.width, height: 150)
//        textLayer.displayIfNeeded()
//        layer.addSublayer(textLayer)
//    }
//
//}
