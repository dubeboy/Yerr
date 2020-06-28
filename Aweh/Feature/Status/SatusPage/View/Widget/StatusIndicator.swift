//
//  StatusIndicator.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/23.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation
import UIKit

class StatusIndicator: UIView { // TODO: shits should not be a UIView
    //    https://useyourloaf.com/blog/adding-padding-to-a-stack-view/
    let stackView = UIStackView()
    
    init(itemCount: Int) {
        super.init(frame: .zero)
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
        stackView.spacing = 2
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8).isActive = true
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
        let trackColor: UIColor = .systemBackground
        trackColor.withAlphaComponent(0.5)
        progressView.trackTintColor = trackColor
        let fillColor: UIColor = .systemBackground
        fillColor.withAlphaComponent(0.8)
        progressView.progressTintColor = fillColor
        
        // Maybe I should set the size of the item here
        return progressView
    }
    
    private func initialiseProgressView(itemCount: Int) {
        for _ in 0..<itemCount {
            let progressView = createProgressView()
            stackView.addArrangedSubview(progressView)
        }
    }
}
