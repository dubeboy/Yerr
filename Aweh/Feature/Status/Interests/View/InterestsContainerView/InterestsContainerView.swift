//
//  InterestCell.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/08.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

enum InterestsContainerConfiguration: Hashable {
    // Associated Value should be a struct so that we can pass in a click listner
    case one(String), two(String, String), three(String, String)
}

// Could have been be a layer 
class InterestsContainerView: UIView {
    
    private var interestsViews: [SingleInterestView] = []
    
    var children: InterestsContainerConfiguration = .one("") {
        didSet {
            configureChildren(children: children)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        interestsViews = []
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InterestsContainerView {
    private func configureSelf() {
        backgroundColor = .clear
    }
    
    private func configureChildren(children: InterestsContainerConfiguration) {
        switch children {
            case .one(let interest):
                configureOneChild(interest)
            case .two(let interest, let interest1):
                configureTwoChildren(interest, interest1)
            case .three(let interest, let interest1):
                configureThreeChildren(interest, interest1)
        }
    }

    // MARK: Helper functions
    
    private func configureThreeChildren(_ interest: String, _ interest1: String) {
        let interestView = SingleInterestView()
        interestView.interest = interest
        let interestView1 = SingleInterestView()
        interestView1.interest = interest1
        let interestView2 = SingleInterestView()
        interestView2.backgroundColor = UIColor.randomPalate.withAlphaComponent(0.6)
        addSubview(interestView)
        addSubview(interestView1)
        addSubview(interestView2)
        
        interestView2.translatesAutoresizingMaskIntoConstraints = false
        interestView2.centerYAnchor --> self.centerYAnchor
        interestView2.leadingAnchor --> self.leadingAnchor + (bounds.width / (4 * 2))
        interestView2.widthAnchor --> (bounds.width / 4)
        interestView2.heightAnchor --> (bounds.height / 4)
        
        interestView1.translatesAutoresizingMaskIntoConstraints = false
        interestView1.bottomAnchor --> self.bottomAnchor
        interestView1.trailingAnchor --> self.trailingAnchor
        interestView1.widthAnchor --> (bounds.width / 2)
        interestView1.heightAnchor --> (bounds.height / 2)
        
        interestView.translatesAutoresizingMaskIntoConstraints = false
        interestView.topAnchor --> self.topAnchor
        interestView.leadingAnchor --> self.leadingAnchor
        interestView.widthAnchor --> (bounds.width / 2)
        interestView.heightAnchor --> (bounds.height / 3)
        
        interestsViews.append(interestView)
        interestsViews.append(interestView1)
        interestsViews.append(interestView2)
    }
    
    private func configureTwoChildren(_ interest: String, _ interest1: String) {
        let interestView = SingleInterestView()
        interestView.interest = interest
        let interestView1 = SingleInterestView()
        interestView1.interest = interest1
        addSubview(interestView)
        addSubview(interestView1)
        interestView1.translatesAutoresizingMaskIntoConstraints = false
        interestView1.bottomAnchor --> self.bottomAnchor
        interestView1.trailingAnchor --> self.trailingAnchor
        interestView1.widthAnchor --> (bounds.width / 2)
        interestView1.heightAnchor --> (bounds.height / 2)
        
        interestView.translatesAutoresizingMaskIntoConstraints = false
        interestView.topAnchor --> self.topAnchor
        interestView.leadingAnchor --> self.leadingAnchor
        interestView.widthAnchor --> (bounds.width / 2)
        interestView.heightAnchor --> (bounds.height / 2)
        
        interestsViews.append(interestView)
        interestsViews.append(interestView1)
    }
    
    private func configureOneChild(_ interest: (String)) {
        let interestView = SingleInterestView()
        interestView.interest = interest
        addSubview(interestView)
        interestView.translatesAutoresizingMaskIntoConstraints = false
        interestView --> self
        interestsViews.append(interestView)
    }
    
    
}

