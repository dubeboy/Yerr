//
//  TimePostVideoRangeSlider.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/23.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

protocol TimePostVideoRangeSliderDelegate: class {
    func didChangeValue(videoRangeSlider: TrimPostVideoRangeSliderView, startTime: Float64, endTime: Float64)
    func indicatorDidChangePosition(videoRangeSlider: TrimPostVideoRangeSliderView, position: Float64)
    
    func sliderGestureBegan()
    func sliderGestureEnded()
}

class TrimPostVideoRangeSliderView: UIView, UIGestureRecognizerDelegate {
    private enum DragHandleChoice {
        case start
        case end
    }
    
    weak var delegate: TimePostVideoRangeSliderDelegate? = nil
    
    var startIndicator = TrimPostVideoStartIndicatorView()
    var endIndicator = TrimPostVideoEndIndicatorView()
    var topLine = TrimPostStatusBoderView()
    var bottomLine = TrimPostStatusBoderView()
    var progressIndicator = TrimPostVideoProgressIndicatorView()
    var draggableView = UIView()
    
    var startTimeView = TrimPostStatusTimeView()
    var endTimeView = TrimPostStatusTimeView()
    
    let thumbnameManager = TrimPostVideoTumbnailsManager()
    var duration: Float64 = 0.0
    var videoURL = URL(fileURLWithPath: "")
    
    var progressPercentage: CGFloat = 0
    var startTimePercentage: CGFloat = 0
    var endTimePercentage: CGFloat = 100
    
    let topBorderHeight: CGFloat = 5
    let bottomBorderHeight: CGFloat = 5
    
    let indicatorWidth: CGFloat = 20.0
    
    let minSpace: Float = 1
    let maxSpace: Float = 0
    
    var isProgressIndicatorSticky: Bool = false
    var isProgressIndicatorDraggable: Bool = false

    var isUpdatingThumbnails = false
    var isReceivingGesture: Bool = false
    
    public enum TimePostVideoStatusPosition {
        case top
        case bottom
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        startTimeView.timeLabel.text = self.secondsToFormattedString(tottalSeconds: secondsFromValue(value: self.startTimePercentage))
        endTimeView.timeLabel.text = self.secondsToFormattedString(tottalSeconds: secondsFromValue(value: self.endTimePercentage))
        
        let startPosition = positionFromValue(value: self.startTimePercentage)
        let endPosition = positionFromValue(value: self.endTimePercentage)
        let progressPosition = positionFromValue(value: self.progressPercentage)
        
        startIndicator.center = CGPoint(x: startPosition, y: startIndicator.center.y)
        endIndicator.center = CGPoint(x: endPosition, y: endIndicator.center.y)
        progressIndicator.center = CGPoint(x: progressPosition, y: progressIndicator.center.y)
        
        draggableView.frame = CGRect(x: startIndicator.frame.origin.x + startIndicator.frame.size.width,
                                     y: 0,
                                     width: endIndicator.frame.origin.x - startIndicator.frame.origin.x - endIndicator.frame.size.width,
                                     height: self.frame.height
        )
        
        topLine.frame = CGRect(x: startIndicator.frame.origin.x + startIndicator.frame.width,
                               y: -topBorderHeight,
                               width: endIndicator.frame.origin.x - startIndicator.frame.origin.x - endIndicator.frame.size.width,
                               height: topBorderHeight)
        
        bottomLine.frame = CGRect(x: startIndicator.frame.origin.x + startIndicator.frame.width,
                                 y: self.frame.size.height,
                                 width: endIndicator.frame.origin.x - startIndicator.frame.origin.x - endIndicator.frame.size.width,
                                 height: bottomBorderHeight)
        
        // update timr view
        
        startTimeView.center = CGPoint(x: startIndicator.center.x, y: startTimeView.center.y)
        endTimeView.center = CGPoint(x: endIndicator.center.x, y: endTimeView.center.y)
    }
}


// MARK: private functions

private extension TrimPostVideoRangeSliderView {
    private func setup() {
        self.isUserInteractionEnabled = true
        
        // setup start indicator
        let startDrag = UIPanGestureRecognizer(target: self, action: #selector(startDragged(recognizer:)))
        startIndicator = TrimPostVideoStartIndicatorView(frame: CGRect(x: 0,
                                                                   y: -topBorderHeight,
                                                                   width: 20,
                                                                   height: self.frame.size.height + bottomBorderHeight + topBorderHeight))
        
        startIndicator.layer.anchorPoint = CGPoint(x: 1, y: 0.5)
        startIndicator.addGestureRecognizer(startDrag)
        self.addSubview(startIndicator)
        
        // setup end indicator
        let endDrag = UIPanGestureRecognizer(target: self, action: #selector(endDragged(recognizer:)))
        endIndicator = TrimPostVideoEndIndicatorView(frame: CGRect(x: 0, y: -topBorderHeight,
                                                               width: indicatorWidth, height: self.frame.size.height + bottomBorderHeight + topBorderHeight))
        endIndicator.layer.anchorPoint = CGPoint(x: 0, y: 0.5)
        endIndicator.addGestureRecognizer(endDrag)
        addSubview(endIndicator)
        
        // setup top and bottom line
        
        topLine = TrimPostStatusBoderView(frame: CGRect(x: 0, y: -topBorderHeight, width: indicatorWidth, height: topBorderHeight))
        addSubview(topLine)
        
        bottomLine = TrimPostStatusBoderView(frame: CGRect(x: 0, y: self.frame.size.height, width: indicatorWidth, height: bottomBorderHeight))
        
        addSubview(bottomLine)
        
        addObserver(self, forKeyPath: "bounds",
                    options: NSKeyValueObservingOptions(rawValue: 0),
                    context: nil)
        
        // setup progress indicator
        
        let progressDrag = UIPanGestureRecognizer(target: self, action: #selector(progressDragged(recognizer:)))
        progressIndicator = TrimPostVideoProgressIndicatorView(frame: CGRect(x: 0, y: -topBorderHeight, width: 10, height: self.frame.size.height + bottomBorderHeight + topBorderHeight))
        
        progressIndicator.addGestureRecognizer(progressDrag)
        addSubview(progressIndicator)
        
        // setup draggable view
        
        let viewDrag = UIPanGestureRecognizer(target: self, action: #selector(viewDragged(recognizer:)))
        draggableView.addGestureRecognizer(viewDrag)
        addSubview(draggableView)
        self.sendSubviewToBack(draggableView)
        
        //MARK: setup time label
        startTimeView = TrimPostStatusTimeView(size: CGSize(width: 60, height: 30))
        startTimeView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addSubview(startTimeView)
        
        endTimeView = TrimPostStatusTimeView(size: CGSize(width: 60, height: 30))
        endTimeView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addSubview(endTimeView)
        
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds" {
            updateThumbnails()
        }
    }
    
    func setProgressIndicatorImage(image: UIImage?) {
        self.progressIndicator.imageView.image = image
    }
    
    func hideProgressIndicator() {
        progressIndicator.isHidden = true
    }
    
    func showProgressIndicator() {
        progressIndicator.isHidden = false
    }
    
    func updateProgressIndicator(seconds: Float64) {
        if !isReceivingGesture {
            let endSeconds = secondsFromValue(value: self.endTimePercentage)
            
            if seconds >= endSeconds {
                self.resetProgressPosition()
            } else {
                self.progressPercentage = self.valueFromSeconds(seconds: Float(seconds))
            }
            
            layoutSubviews()
        }
    }
    
    func setStartIndicatorImage(image: UIImage?) {
        self.startIndicator.imageView.image = image
    }
    
    func setEndIndicatorImage(image: UIImage?) {
        self.endIndicator.imageView.image = image
    }
    
    func setBorderImage(image: UIImage?) {
        self.topLine.imageView.image = image
        self.bottomLine.imageView.image = image
    }
    
    func setTimeView(view: TrimPostStatusTimeView) {
        startTimeView = view
        endTimeView = view
    }
    
    func setVideoURL(videoURL: URL) {
        self.duration = TrimPostVideoTumbnailsManager.videoDuration(videoURL: videoURL)
        self.videoURL = videoURL
        self.superview?.layoutSubviews()
        self.updateThumbnails()
    }
    
    func updateThumbnails() {
        if !isUpdatingThumbnails {
            self.isUpdatingThumbnails = true
            let backgroundQueue = DispatchQueue(label: "com.app.queue", qos: .background, target: nil)
            backgroundQueue.async {
                _ = self.thumbnameManager.updateThumbnails(view: self, videoURL: self.videoURL, duration: self.duration)
                self.isUpdatingThumbnails = true
            }
        }
    }
    
    func setStartPosition(seconds: Float) {
        self.startTimePercentage = self.valueFromSeconds(seconds: seconds)
        layoutSubviews()
    }
    
    func setEndPosition(seconds: Float) {
        self.endTimePercentage = self.valueFromSeconds(seconds: seconds)
        layoutSubviews()
    }
    
    
    private func secondsFromValue(value: CGFloat) -> Float64 {
        return duration + Float64((value / 100))
    }
    
    private func valueFromSeconds(seconds: Float) -> CGFloat {
        return CGFloat(seconds * 100) / CGFloat(duration)
    }
    
    private func updateGestureStatus(recognizer: UIGestureRecognizer) {
        if recognizer.state == .began {
            self.isReceivingGesture = true
            self.delegate?.sliderGestureBegan()
        } else if recognizer.state == .ended {
            self.isReceivingGesture = false
            self.delegate?.sliderGestureEnded()
        }
    }
    
    private func resetProgressPosition() {
        self.progressPercentage = self.startTimePercentage
        let progressPosition = positionFromValue(value: self.progressPercentage)
        progressIndicator.center = CGPoint(x: progressPosition, y: progressIndicator.center.y)
        
        let startSeconds = secondsFromValue(value: self.progressPercentage)
        self.delegate?.indicatorDidChangePosition(videoRangeSlider: self, position: startSeconds)
    }
}


// MARK: Private functions

private extension TrimPostVideoRangeSliderView {
    @objc private func startDragged(recognizer: UIPanGestureRecognizer) {
        self.processHandleDrag(recognizer: recognizer, drag: .start,
                               currentPostionPercentage: self.startTimePercentage,
                               currentIndicator: startIndicator)
    }
    
    @objc private func endDragged(recognizer: UIPanGestureRecognizer) {
        self.processHandleDrag(recognizer: recognizer,
                               drag: .end,
                               currentPostionPercentage: self.endTimePercentage,
                               currentIndicator: endIndicator)
    }
    
    @objc private func progressDragged(recognizer: UIPanGestureRecognizer) {
        if !isProgressIndicatorDraggable {
            return
        }
        
        updateGestureStatus(recognizer: recognizer)
        
        let translation = recognizer.translation(in: self)
        
        let positionLimitStart = positionFromValue(value: self.startTimePercentage)
        let positionLimitEnd = positionFromValue(value: self.endTimePercentage)
        
        var position = positionFromValue(value: self.progressPercentage)
        position = position + translation.x
        
        if position < positionLimitStart {
            position = positionLimitStart
        }
        
        if position > positionLimitEnd {
            position = positionLimitEnd
        }
        
        recognizer.setTranslation(.zero, in: self)
        
        progressIndicator.center = CGPoint(x: position, y: progressIndicator.center.y)
        
        let percentage = progressIndicator.center.x * 100 / self.frame.width
        
        let progressSeconds = secondsFromValue(value: progressPercentage)
        
        self.delegate?.indicatorDidChangePosition(videoRangeSlider: self, position: progressSeconds)
        self.progressPercentage = percentage
        
        layoutSubviews()
    }
    
    @objc private func viewDragged(recognizer: UIPanGestureRecognizer) {
        updateGestureStatus(recognizer: recognizer)
        
        let translation = recognizer.translation(in: self)
        
        var progressPosition = positionFromValue(value: self.progressPercentage)
        var startPosition = positionFromValue(value: self.startTimePercentage)
        var endPosition = positionFromValue(value: self.endTimePercentage)
        
        startPosition = startPosition + translation.x
        endPosition = endPosition + translation.x
        progressPosition = progressPosition + translation.x
        
        if startPosition < 0 {
            startPosition = 0
            endPosition = endPosition - translation.x
            progressPosition = progressPosition - translation.x
        }
        
        if endPosition > self.frame.size.width {
            endPosition = self.frame.size.width
            startPosition = startPosition - translation.x
            progressPosition = progressPosition - translation.x
        }
        
        recognizer.setTranslation(.zero, in: self)
        
        progressIndicator.center = CGPoint(x: progressPosition, y: progressIndicator.center.y)
        startIndicator.center = CGPoint(x: startPosition, y: startIndicator.center.y)
        endIndicator.center = CGPoint(x: endPosition, y: endIndicator.center.y)
        
        let startPercentage = startIndicator.center.x * 100 / self.frame.width
        let endPercentage = endIndicator.center.x * 100 / self.frame.width
        let progressPercentage = progressIndicator.center.x * 100 / self.frame.width
        
        let startSeconds = secondsFromValue(value: startPercentage)
        let endSeconds = secondsFromValue(value: endPercentage)
        
        self.delegate?.didChangeValue(videoRangeSlider: self, startTime: startSeconds, endTime: endSeconds)
        
        if self.progressPercentage != progressPercentage {
            let progressSeconds = secondsFromValue(value: progressPercentage)
            self.delegate?.indicatorDidChangePosition(videoRangeSlider: self, position: progressSeconds)
        }
        
        self.startTimePercentage = startPercentage
        self.endTimePercentage = endPercentage
        self.progressPercentage = progressPercentage
        
        layoutSubviews()
    }
    
    func positionFromValue(value: CGFloat) -> CGFloat {
        let position = value * self.frame.size.width / 100
        return position
    }
    
    private func getPositionLimits(with drag: DragHandleChoice) -> (min: CGFloat, max: CGFloat) {
        if drag == .start {
            return (positionFromValue(value: self.endTimePercentage - valueFromSeconds(seconds: self.minSpace)),
                    positionFromValue(value: self.endTimePercentage - valueFromSeconds(seconds: self.maxSpace)))
        } else {
            return (positionFromValue(value: self.startTimePercentage + valueFromSeconds(seconds: self.minSpace)),
                    positionFromValue(value: self.startTimePercentage + valueFromSeconds(seconds: self.maxSpace)))
        }
    }
    
    private func checkEdgeCaseForPosition(with position: CGFloat, and positionLimit: CGFloat, and drag: DragHandleChoice) -> CGFloat {
        if drag == .start {
            if Float(self.duration) < self.minSpace {
                return 0
            } else {
                if position > positionLimit {
                    return positionLimit
                }
            }
        } else {
            if Float(self.duration) < self.minSpace {
                return self.frame.size.width
            } else {
                if position < positionLimit {
                    return positionLimit
                }
            }
        }
        
        return position
    }
    
    private func processHandleDrag(recognizer: UIPanGestureRecognizer,
                                   drag: DragHandleChoice,
                                   currentPostionPercentage: CGFloat,
                                   currentIndicator: UIView) {
        self.updateGestureStatus(recognizer: recognizer)
        let translation = recognizer.translation(in: self)
        var position: CGFloat = positionFromValue(value: currentPostionPercentage) // self.startPercentage or self.endPercentage
        
        position = position + translation.x
        
        if position < 0 { position = 0 }
        
        if position > self.frame.size.width {
            position = self.frame.size.width
        }
        
        let positionLimits = getPositionLimits(with: drag)
        position = checkEdgeCaseForPosition(with: position, and: positionLimits.min, and: drag)
        
        if Float(self.duration) > self.maxSpace && self.maxSpace > 0 {
            if drag == .start {
                if position < positionLimits.max {
                    position = positionLimits.max
                }
            } else {
                if position > positionLimits.max {
                    position = positionLimits.max
                }
            }
        }
        
        recognizer.setTranslation(.zero, in: self)
        currentIndicator.center = CGPoint(x: position, y: currentIndicator.center.y)
        
        let percentage = currentIndicator.center.x * 100 / self.frame.width
        
        let startSeconds = secondsFromValue(value: self.startTimePercentage)
        let endSeconds = secondsFromValue(value: self.endTimePercentage)
        
        self.delegate?.didChangeValue(videoRangeSlider: self, startTime: startSeconds, endTime: endSeconds)
        
        var progressPosition: CGFloat = 0.0
        
        if drag == .start {
            self.startTimePercentage = percentage
        } else {
            self.endTimePercentage = percentage
        }
        
        if drag == .start {
            progressPosition = positionFromValue(value: self.startTimePercentage)
        } else {
            if recognizer.state != .ended {
                progressPosition = positionFromValue(value: self.endTimePercentage)
            } else {
                progressPosition = positionFromValue(value: self.startTimePercentage)
            }
        }
        
        progressIndicator.center = CGPoint(x: progressPosition, y: progressIndicator.center.y)
        let progressPercentage = progressIndicator.center.x * 100 / self.frame.width
        
        if self.progressPercentage != progressPercentage {
            let progressSeconds = secondsFromValue(value: progressPercentage)
            self.delegate?.indicatorDidChangePosition(videoRangeSlider: self, position: progressSeconds)
        }
        
        self.progressPercentage = progressPercentage
        
        layoutSubviews()
    }
    
    private func secondsToFormattedString(tottalSeconds: Float64) -> String {
        let hours: Int = Int(tottalSeconds.truncatingRemainder(dividingBy: 86400) / 3600)
        let minutes: Int = Int(tottalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
        let seconds: Int = Int(tottalSeconds.truncatingRemainder(dividingBy: 60))
        
        if hours > 0 {
            return String(format: "%i:%02i:%02i", hours, minutes, seconds)
        } else {
            return String(format: "%02i:%02i", minutes, seconds)
        }
    }
}
