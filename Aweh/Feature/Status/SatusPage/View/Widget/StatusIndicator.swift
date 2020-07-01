//
//  StatusIndicator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/23.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import UIKit

protocol StatusTimoutDelegate: AnyObject {
    func timeout()
}

//enum Timer

// status lasts 30 secs video
// images 5 secs
class StatusIndicator: UIView { // TODO: shits should not be a UIView
    //    https://useyourloaf.com/blog/adding-padding-to-a-stack-view/
    let stackView = UIStackView()
    weak var delegate: StatusTimoutDelegate?
    private var runCount: Float = 0.0
    private var timer: Timer?
    private var statusIndicatorIndex: Int = 0
    
    init(itemCount: Int, delegate: StatusTimoutDelegate? = nil) {
        self.delegate = delegate
        super.init(frame: .zero)
        timer = scheduledTimer()
        setupStackView()
        initialiseProgressView(itemCount: itemCount)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStackView() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0).isActive = true // TODO: - fix at some point in the future
        stackView.topAnchor --> topAnchor
        stackView.bottomAnchor --> bottomAnchor
    }
    
    private func createProgressView() -> UIProgressView {
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progress = 0.5
        let transform = CGAffineTransform(scaleX: 1.0, y: 2.0);
        progressView.transform = transform;
        progressView.layer.cornerRadius = 2
        progressView.clipsToBounds = true
        progressView.layer.sublayers![1].cornerRadius = 2
        progressView.subviews[1].clipsToBounds = true
        let trackColor: UIColor = .cyan
//        let comp = trackColor.withAlphaComponent(0.4)
        progressView.trackTintColor = trackColor
        let fillColor: UIColor = .black
//        let _ = fillColor.withAlphaComponent(0.8) // TODO: use these
        progressView.progressTintColor = fillColor
        return progressView
    }
    
    private func initialiseProgressView(itemCount: Int) {
        for _ in 0..<itemCount {
            let progressView = createProgressView()
            stackView.addArrangedSubview(progressView)
        }
    }
    
    func setCurrentStatusAt(statusIndex: Int) {
        timer?.invalidate()
        runCount = 0
        statusIndicatorIndex = statusIndex
        timer = scheduledTimer()
    }
    
    // TODO: - Using a timer isnt the best sulution
    @objc func timerAction() {
        let maxTime: Float = 60.0 * 3.0
        guard runCount <= maxTime else {
            timer?.invalidate()
            delegate?.timeout()
            return
        }
        runCount += 9
        let progress: Float = runCount / maxTime
        let progressView = stackView.arrangedSubviews[statusIndicatorIndex] as? UIProgressView
        progressView!.setProgress(progress, animated: true) //NB: Force unwrap
        print("\(runCount)")
        print("run percent: \(progress)")
    }
    
    private func scheduledTimer() -> Timer {
        Timer
            .scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
}

