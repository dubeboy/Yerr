//
//  CommentView.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/09/09.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit
import Photos

class CommentBoxView: UIView, UITextViewDelegate {
    
    enum DisplayType: Equatable {
        case compact(UITextView), full
    }
    
    private static let indicatorWidth: Double = 25
    
    @LateInit
    private var circleProgressIndicator: CircleProgressIndicatorView
    @LateInit
    private var iconsView: UIView
    @LateInit
    private var containerStackView: UIStackView
    @LateInit
    private var commentTextView: UITextView
    @LateInit
    private(set) var selectPhotosButton: YerrButton
    @LateInit
    private(set) var replyButton: YerrButton
    @LateInit
    private var commentTextViewDelegate: TextViewDelegateImplementation
    @LateInit
    private var assetsHorizontalListView: AssetsHorizontalListView
    
    var delegate: ((Int) -> Void)?
   
    var placeHolderText: String = AppStrings.FeedDetail.replyPlaceholderText
    
    private var displayType: DisplayType
   
    init(displayType: DisplayType = .full) {
        self.displayType = displayType
        super.init(frame: .zero)
        switch displayType {
            case .full:
                commentTextView = UITextView(frame: .zero)
            case .compact(let textView):
                commentTextView = textView
        }
        
        containerStackView = UIStackView(frame: .zero)
        containerStackView = UIStackView(frame: .zero)
        commentTextViewDelegate = TextViewDelegateImplementation(delegate: self)
        selectPhotosButton = YerrButton(type: .custom)
        replyButton = YerrButton(frame: .zero)
        iconsView = UIView()
        circleProgressIndicator = CircleProgressIndicatorView()
        assetsHorizontalListView = AssetsHorizontalListView()
        
        configureSelf()
        configureImageHStack()
        configureInputBox()
        configureIconsView()
        addIconsToIconsStackView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupConstraintsForIcons()
        setupConstraintsForCommentsBox()
    }
    
    func commentText() -> String {
        return commentTextView.text
    }
    
    func changeDisplayType(displayType: DisplayType) {}
    
    func textViewBecomeFirstResponder() {
        commentTextView.becomeFirstResponder()
    }
    
    func showImageAssets(assets: [String: PHAsset]) {
//        let view = UIView()
//        view.backgroundColor = .red
//        view.heightAnchor --> 60
//        containerStackView.addSubview()
        assetsHorizontalListView.addImages(assets: assets)
        assetsHorizontalListView.isHidden = false
    }
}

// --------
// MARK: Constrants Setup Private Functions
// --------

private extension CommentBoxView {
    
    private func configureSelf() {
        self.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.axis = .vertical
        containerStackView.spacing = Const.View.m8
        containerStackView.alignment = .fill
        containerStackView.distribution = .fillProportionally
        addSubview(containerStackView)
        
        containerStackView.bottomAnchor --> self.bottomAnchor + -Const.View.m8
        containerStackView.topAnchor --> self.topAnchor + Const.View.m8
        containerStackView.leadingAnchor --> self.leadingAnchor + Const.View.m16
        containerStackView.trailingAnchor --> self.trailingAnchor + -Const.View.m16
        
        self.addDividerLine(to: [.top])
        self.backgroundColor = Const.Color.systemWhite
    }
    
    private func configureImageHStack() {
        assetsHorizontalListView.translatesAutoresizingMaskIntoConstraints = false
        containerStackView.addArrangedSubview(assetsHorizontalListView)
        assetsHorizontalListView.isHidden = true
    }
    
    private func configureIconsView() {
        iconsView.translatesAutoresizingMaskIntoConstraints = false
        iconsView.heightAnchor --> 40
        containerStackView.addArrangedSubview(iconsView)
    }
    
    private func configureInputBox() {
        if displayType == .full {
            containerStackView.addArrangedSubview(commentTextView)
        }
        commentTextView.delegate = commentTextViewDelegate
        commentTextView.isScrollEnabled = false // Allows automatic height adjustment
        commentTextView.backgroundColor = Const.Color.Feed.commentBox
        commentTextView.layer.cornerRadius = 1.5 * Const.View.radius
        let textContentInset = (1.5 * Const.View.radius) / 2
        commentTextView.textContainerInset = UIEdgeInsets(top: Const.View.m12, left: textContentInset, bottom: Const.View.m12, right: textContentInset)
        
    }
    
    private func createIconsStackView() -> UIStackView {
        let iconsStackView = UIStackView()
        iconsStackView.axis = .horizontal
        iconsStackView.spacing = Const.View.m8
        iconsStackView.alignment = .fill
        iconsStackView.distribution = .fillProportionally
        return iconsStackView
    }
    
    private func configureCircleProgressIndicator() {
        circleProgressIndicator.translatesAutoresizingMaskIntoConstraints = false
        circleProgressIndicator.heightAnchor --> 30
        circleProgressIndicator.widthAnchor --> 30
    }
    
    private func addRightIcons() {
        configureReplyButton(button: replyButton)
        configureCircleProgressIndicator()
        
        let rightStackView = createIconsStackView()
        rightStackView.alignment = .center
        rightStackView.translatesAutoresizingMaskIntoConstraints = false
        iconsView.addSubview(rightStackView)
        rightStackView.topAnchor --> iconsView.topAnchor
        rightStackView.bottomAnchor --> iconsView.bottomAnchor
        rightStackView.trailingAnchor --> iconsView.trailingAnchor
        rightStackView.addArrangedSubview(circleProgressIndicator)
        rightStackView.addArrangedSubview(replyButton)
    }
    
    private func addLeftIcons() {
        configurePhotosButton(button: selectPhotosButton)
        
        let leftIconsStackView = createIconsStackView()
        leftIconsStackView.addArrangedSubview(selectPhotosButton)
        leftIconsStackView.translatesAutoresizingMaskIntoConstraints = false
        iconsView.addSubview(leftIconsStackView)
        leftIconsStackView.topAnchor --> iconsView.topAnchor
        leftIconsStackView.bottomAnchor --> iconsView.bottomAnchor
        leftIconsStackView.leadingAnchor --> iconsView.leadingAnchor
    }
    
    private func addIconsToIconsStackView() {
        addLeftIcons()
        addRightIcons()
    }
    
    
    private func configureReplyButton(button: UIButton) {
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(AppStrings.FeedDetail.replyButton, for: .normal)
        button.backgroundColor = Const.Color.actionButtonColor
        button.isEnabled = false
    }
    
    private func configurePhotosButton(button: UIButton) {
        selectPhotosButton.setImage(Const.Assets.FeedDetail.iconImage, for: .normal)
        selectPhotosButton.tintColor = Const.Color.actionButtonColor
        // TODO: fix selectde| higlighted states for tinted image
        button.layer.borderWidth = Const.View.borderWidth
        button.layer.masksToBounds = true
        button.layer.borderColor = Const.Color.lightGray.cgColor
    }
    
    // TODO: to be used for do something awesome one day!!!
    private func setupConstraintsForIcons() {
       
//        iconsStackView.heightAnchor --> 40
//        circleProgressIndicator.translatesAutoresizingMaskIntoConstraints = false
//        circleProgressIndicator.widthAnchor --> 40
//        circleProgressIndicator.heightAnchor --> 40
//        replyButton.translatesAutoresizingMaskIntoConstraints = false
//        replyButton.widthAnchor --> 40
//        replyButton.heightAnchor --> 40
//        selectePhotosButton.translatesAutoresizingMaskIntoConstraints = false
//        selectePhotosButton.heightAnchor --> 40
//        selectePhotosButton.widthAnchor --> 40
    }
    
    private func setupConstraintsForCommentsBox() {
        
    }

}
// ------
// MARK: TextView delegate extension
// ------

extension CommentBoxView: TextViewTextUpdatedDelegate {
    var sendButton: UIButton {
        replyButton
    }
    
    func numberOfCharectorsDidChange(current length: Int) {
        
        if length > 0 {
            let percent: Double = (Double(length) / Double(Const.maximumTextLength)) * 100.0
            updateProgressRingColor(percent: percent)
            circleProgressIndicator.updateProgress(percent: CGFloat(percent))
            circleProgressIndicator.updateProgressLabel(text: "\(length)")
        } else {
            updateProgressRingColor(percent: 0.0)
            circleProgressIndicator.updateProgress(percent: 0.0)
            circleProgressIndicator.updateProgressLabel(text: "")
        }
    }
    
    private func updateProgressRingColor(percent: Double) {
        if percent >= 0.0 && percent < 70.0 {
            circleProgressIndicator.resetColors()
        } else if percent >= 70.0 && percent < 90.0 {
            circleProgressIndicator.updateProgressRingColor(color: Const.Color.Feed.warningMaximumTextLength)
        } else {
            circleProgressIndicator.updateProgressRingColor(color: Const.Color.Feed.alertMaximumTextLength)
        }
    }
}

