//
//  TextViewActionsView.swift
//  Aweh
//
//  Created by Divine.Dube on 2021/01/10.
//  Copyright © 2021 com.github.aweh. All rights reserved.
//

import UIKit

protocol TextViewActionsViewDelegate {
    func didTapTextAlignment(alignment: PostStatusViewModel.TextAlignment)
    func didTapColorToChange(tag: Int)
    func didTapBoldText(textWeight: PostStatusViewModel.TextWeight)
    func didTapDoneActionButton()
}

class TextViewActionsView: UIView {
    
    private let actionsToolbar = UIToolbar()
    private let secondaryActionsView = UIView()
    private let secondaryActionsScrollView = UIScrollView()
    private let contantsStackView = UIStackView()
    private let blurEffectView = UIVisualEffectView(effect: nil)
    private let bottomSafeAreaView = UIView()
    private let colors: [String]
    
    private let tagForDidTapBackgroundColor = 1001
    private var selectedTextAlignment: PostStatusViewModel.TextAlignment = .center
    private var textWeight: PostStatusViewModel.TextWeight = .normal
    private let delegate: TextViewActionsViewDelegate
    init(delegate: TextViewActionsViewDelegate, colors: [String]) {
        self.colors = colors
        self.delegate = delegate
        super.init(frame: .zero)
        configureActionsToolbar()
        configureSecondaryActionsToolbar()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomSafeAreaView.heightAnchor --> safeAreaInsets.bottom
    }
    
    @objc func didTapChangeBackgroundColorButton(_ sender: UIBarButtonItem) {
        hideBlurEffectView(isHidden: !blurEffectView.isHidden)
        if tagForDidTapBackgroundColor != contantsStackView.tag {
            contantsStackView.arrangedSubviews.forEach {
                $0.removeFromSuperview()
            }
            for (index, color) in colors.enumerated() {
                
                let button = YerrButton()
               
                guard let image = Const.Assets.PostStatus.color?.withRenderingMode(.alwaysTemplate) else { return }
                button.setImage(fillBoundsWith: image, for: .normal)
                button.tag = index
                button.smoothCornerCurve()
                button.tintColor = UIColor(hex: color)
                button.addTarget(self, action: #selector(didTapColorToChange(_:)), for: .touchUpInside)
                
                self.contantsStackView.addArrangedSubview(button)
                button.autoresizingOff()
                button.widthAnchor --> 24.33
                button.heightAnchor --> 24.33
               
            }
            let button = UIView()
            let gradientView = GradientView()
            gradientView.isUserInteractionEnabled = true
            button.isUserInteractionEnabled = true
            gradientView.autoresizingOff()
            button.addSubview(gradientView)
            gradientView --> button
            button.clipsToBounds = true
            button.layer.cornerRadius = 22.33 / 2
            button.smoothCornerCurve()
            button.tag = -1
            gradientView.tag = -1
            button.widthAnchor --> 22.33
            button.heightAnchor --> 22.33
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapGradientColor(_:)))
            gradientView.addGestureRecognizer(tapGesture)
           
//            button.addTarget(self, action: #selector(didTapColorToChange(_:)), for: .touchUpInside)
            self.contantsStackView.addArrangedSubview(button)
            secondaryActionsScrollView.contentSize = CGSize(width: (30) * colors.count , height: 50)
            contantsStackView.tag = tagForDidTapBackgroundColor
        }
    }
    
    @objc func didTapGradientColor(_ sender: UITapGestureRecognizer) {
        delegate.didTapColorToChange(tag: sender.view?.tag ?? 0)
    }
    
    // TODO: record how many people click this button to find the prefred text alignment
    @objc func didTapTextAlignment(_ sender: UIBarButtonItem) {
        blurEffectView.isHidden = true
        if sender.image == Const.Assets.PostStatus.testAlignmentLeft {
            sender.image = Const.Assets.PostStatus.textAlignmentCenter
            delegate.didTapTextAlignment(alignment: .center)
        } else if sender.image == Const.Assets.PostStatus.textAlignmentCenter {
            sender.image = Const.Assets.PostStatus.testAlignmentRight
            delegate.didTapTextAlignment(alignment: .right)
        } else if  sender.image == Const.Assets.PostStatus.testAlignmentRight {
            sender.image = Const.Assets.PostStatus.testAlignmentLeft
            delegate.didTapTextAlignment(alignment: .right)
        }
    }
    
    @objc private func didTapColorToChange(_ sender: UIButton) {

        delegate.didTapColorToChange(tag: sender.tag)
    }
    
    @objc func didTapBoldText(_ sender: UIBarButtonItem) {
        //        statusTextView.font = UIFont.preferredFont(forTextStyle: .body)
        //        statusTextView.adjustsFontForContentSizeCategory = true
        if textWeight == .normal {
            sender.image = Const.Assets.PostStatus.boldText
            textWeight = .bold
            delegate.didTapBoldText(textWeight: .bold)
        } else if textWeight == .bold {
            sender.image = Const.Assets.PostStatus.italicText
            textWeight = .italic
            delegate.didTapBoldText(textWeight: .italic)
        } else {
            sender.image = Const.Assets.PostStatus.normalText
            textWeight = .normal
            delegate.didTapBoldText(textWeight: .normal)
        }
    }
    
    @objc func didTapChangeTextbackground() {
        
    }
    
    @objc func didTapDoneActionButton() {
        delegate.didTapDoneActionButton()
    }
}

// MARK: - Helper functions

extension TextViewActionsView {
    private func configureActionsToolbar() {
        configureBottomSafeAreaView()
        actionsToolbar.frame = CGRect(x: 0, y: 0, width: frame.width, height: 50)
        actionsToolbar.autoresizingOff()
        addSubview(actionsToolbar)
        actionsToolbar.leadingAnchor --> leadingAnchor
        actionsToolbar.trailingAnchor --> trailingAnchor
        actionsToolbar.bottomAnchor --> bottomSafeAreaView.topAnchor
        
        let doneButton = YerrButton(type: .system)
        doneButton.frame = CGRect(x: 0, y: 0, width: 60, height: 50)
        doneButton.setTitle("Done", for: .normal)
        doneButton.autoresizesSubviews = true
        doneButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        doneButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        doneButton.addTarget(self, action: #selector(didTapDoneActionButton), for: .touchUpInside)
        // TODO : style button here!!!
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButton = UIBarButtonItem(customView: doneButton)
        let barButtonBackgroundColor = UIBarButtonItem(image: Const.Assets.PostStatus.color, style: .plain,
                                                       target: self, action: #selector(didTapChangeBackgroundColorButton))
        let batButtomTextAlignment = UIBarButtonItem(image: Const.Assets.PostStatus.textAlignmentCenter, style: .plain,
                                                     target: self, action: #selector(didTapTextAlignment))
        let barButtonBoldText = UIBarButtonItem(image: Const.Assets.PostStatus.boldText, style: .plain,
                                                target: self, action: #selector(didTapBoldText))
        let barButtonChangeTextBackground = UIBarButtonItem(image: Const.Assets.PostStatus.changeTextBackground, style: .plain,
                                                            target: self, action: #selector(didTapChangeTextbackground))
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = Const.View.m12
        actionsToolbar.setItems([barButtonBackgroundColor,
                                 fixedSpace,
                                 batButtomTextAlignment,
                                 fixedSpace, barButtonBoldText,
                                 fixedSpace,
                                 barButtonChangeTextBackground,
                                 spacer,
                                 barButton], animated: false)

    }
    
    private func hideBlurEffectView(isHidden: Bool) {
        blurEffectView.isHidden = isHidden
    }
    
    private func configureSecondaryActionsToolbar() {
        
        blurEffectView.autoresizingOff()
        secondaryActionsView.autoresizingOff()
        
        //        blurEffectView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        addSubview(blurEffectView)
        blurEffectView.autoresizingOff()
        blurEffectView.leadingAnchor --> leadingAnchor
        blurEffectView.trailingAnchor --> trailingAnchor
        blurEffectView.heightAnchor --> 50
        blurEffectView.bottomAnchor --> actionsToolbar.topAnchor
        blurEffectView.topAnchor --> topAnchor
        blurEffectView.contentView.addSubview(secondaryActionsView)
        blurEffectView.effect = UIBlurEffect(style: .prominent) // TODO: change blur effect
        
        configureScrollView()
        secondaryActionsView.addSubview(secondaryActionsScrollView)
        secondaryActionsScrollView --> secondaryActionsView
        
        configureStackView()
        secondaryActionsScrollView.addSubview(contantsStackView)
        contantsStackView.leadingAnchor --> secondaryActionsScrollView.leadingAnchor + (Const.View.m16)
        contantsStackView.heightAnchor --> secondaryActionsScrollView.heightAnchor
        contantsStackView.centerYAnchor --> secondaryActionsScrollView.centerYAnchor
        
        secondaryActionsView --> blurEffectView
        hideBlurEffectView(isHidden: true)
    }
    
    private func configureBottomSafeAreaView() {
        bottomSafeAreaView.autoresizingOff()
        addSubview(bottomSafeAreaView)
        bottomSafeAreaView.leadingAnchor --> leadingAnchor
        bottomSafeAreaView.trailingAnchor --> trailingAnchor
       
        bottomSafeAreaView.bottomAnchor --> bottomAnchor
    }
    
    private func configureScrollView() {
        secondaryActionsScrollView.autoresizingOff()
        //        secondaryActionsScrollView.isPagingEnabled = true
    }
    
    private func configureStackView() {
        contantsStackView.autoresizingOff()
        contantsStackView.alignment = .center
        contantsStackView.distribution = .fillProportionally
        contantsStackView.axis = .horizontal
        contantsStackView.spacing = Const.View.m16
    }
}
