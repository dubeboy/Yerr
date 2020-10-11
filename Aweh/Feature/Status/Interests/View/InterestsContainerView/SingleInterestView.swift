//
//  SingleInterestView.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/09.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

protocol SingleInterestViewDelegate {
    func didClickSingleIntrestView(name: String)
}

class SingleInterestView: UIView {
    private let label: UILabel = UILabel(frame: .zero)
    
    @LateInit
    private var blurView: UIVisualEffectView
    
    var interest: String = "" {
        didSet {
            label.text = interest
            backgroundColor = .random(from: interest)
            blurView.isHidden = false
        }
    }
    
    var delegate: SingleInterestViewDelegate? = nil {
        didSet {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            removeGestureRecognizer(tapGesture)
            addGestureRecognizer(tapGesture)
            // TODO Test: assets this please
        }
    }
    
    @objc private func handleTap() {
        delegate?.didClickSingleIntrestView(name: interest)
    }

//    let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
//    myView.addGestureRecognizer(tap)
    
//    func setDelegate(delegate: SingleInterestViewDelegate) {
//        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(delegate.didClickSingleIntrestView))
//        //        gestureRecognizers = []
//        //        addGestureRecognizer(tapGesture)
//        //    }
    
    init() {
        super.init(frame: .zero)
        let blurEffect = UIBlurEffect(style: .systemThinMaterialLight)
        blurView = UIVisualEffectView(effect: blurEffect)
        configureSelf()
        configureBlurView()
        configureLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SingleInterestView {
    
    private func configureSelf() {
        layer.cornerRadius = Const.View.radius
        layer.masksToBounds = true
        isUserInteractionEnabled = true
        
        addShadow()
    }
    
    
    private func configureBlurView() {
        addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.leadingAnchor --> self.leadingAnchor
        blurView.trailingAnchor --> self.trailingAnchor
        // TODO; add gradient here
        blurView.bottomAnchor --> self.bottomAnchor + -Const.View.m8
        blurView.isHidden = true
        blurView.backgroundColor = Const.Color.systemWhite.withAlphaComponent(0.6)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.clipsToBounds = true
        blurView.layer.masksToBounds = true
    }
    
    private func configureLabel() {
        blurView.contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.topAnchor --> blurView.topAnchor + Const.View.m4
        label.bottomAnchor --> blurView.bottomAnchor + -Const.View.m4
        label.leadingAnchor --> blurView.leadingAnchor + Const.View.m8
        label.trailingAnchor --> blurView.trailingAnchor + -Const.View.m8
    }
}
