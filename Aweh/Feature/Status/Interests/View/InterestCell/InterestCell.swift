//
//  InterestCell.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/08.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class InterestCellContainerView: UIView {
    
    enum ContainerConfiguration {
        case one(String), two(String, String), three(String, String)
    }
        
    
    var interestsViews: [InterestView] = []
    var children: ContainerConfiguration
    private static let containerViewRect = CGRect(x: 0, y: 0, width: 100, height: 150)

    init(children: ContainerConfiguration) {
        self.children = children
        super.init(frame: Self.containerViewRect)
        interestsViews = []
        configureSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InterestCellContainerView {
    private func configureSelf() {
        backgroundColor = .clear
        layer.cornerRadius = Const.View.radius
        addShadow()
    }
    
    private func configureChildren() {
        switch children {
            case .one(let interest):
                let interestView = InterestView()
                interestView.interest = interest
                addSubview(interestView)
                interestView.translatesAutoresizingMaskIntoConstraints = false
                interestView --> self
                interestsViews.append(interestView)
            case .two(let interest, let interest1):
                let interestView = InterestView()
                interestView.interest = interest
                let interestView1 = InterestView()
                interestView.interest = interest1
                addSubview(interestView)
                addSubview(interestView1)
                interestView1.translatesAutoresizingMaskIntoConstraints = false
                interestView1.bottomAnchor --> self.bottomAnchor
                interestView1.trailingAnchor --> self.trailingAnchor
                interestView1.widthAnchor --> (Self.containerViewRect.width / 2)
                interestView1.heightAnchor --> (Self.containerViewRect.height / 2)
                
                interestView.translatesAutoresizingMaskIntoConstraints = false
                interestView.topAnchor --> self.topAnchor
                interestView.leadingAnchor --> self.leadingAnchor
                interestView.widthAnchor --> (Self.containerViewRect.width / 2)
                interestView.heightAnchor --> (Self.containerViewRect.height / 2)
                
                interestsViews.append(interestView)
                interestsViews.append(interestView1)
            case .three(let interest, let interest1):
                let interestView = InterestView()
                interestView.interest = interest
                let interestView1 = InterestView()
                interestView1.interest = interest1
                let interestView2 = InterestView()
                interestView2.backgroundColor = UIColor.randomPalate.withAlphaComponent(0.6)
                addSubview(interestView)
                addSubview(interestView1)
                addSubview(interestView2)
                
                interestView2.translatesAutoresizingMaskIntoConstraints = false
                interestView2.centerYAnchor --> self.centerYAnchor
                interestView2.leadingAnchor --> self.leadingAnchor + (Self.containerViewRect.width / (4 * 2))
                interestView2.widthAnchor --> (Self.containerViewRect.width / 4)
                interestView2.heightAnchor --> (Self.containerViewRect.height / 4)
                
                interestView1.translatesAutoresizingMaskIntoConstraints = false
                interestView1.bottomAnchor --> self.bottomAnchor
                interestView1.trailingAnchor --> self.trailingAnchor
                interestView1.widthAnchor --> (Self.containerViewRect.width / 2)
                interestView1.heightAnchor --> (Self.containerViewRect.height / 2)
                
                interestView.translatesAutoresizingMaskIntoConstraints = false
                interestView.topAnchor --> self.topAnchor
                interestView.leadingAnchor --> self.leadingAnchor
                interestView.widthAnchor --> (Self.containerViewRect.width / 2)
                interestView.heightAnchor --> (Self.containerViewRect.height / 3)
                
                interestsViews.append(interestView)
                interestsViews.append(interestView1)
                interestsViews.append(interestView2)
        }
    }
}

class InterestView: UIView {
    private let label: UILabel = UILabel(frame: .zero)
    
    var interest: String = "" {
        didSet {
            label.text = interest
            backgroundColor = .randomPalate(from: interest)
        }
    }
    
    init() {
        super.init(frame: .zero)
        configureSelf()
        congfigureIntrestLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension InterestView {
    
    private func configureSelf() {
        layer.cornerRadius = Const.View.radius
    }
    
    private func congfigureIntrestLabel() {
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        label.textAlignment = .left
        label.leadingAnchor --> self.leadingAnchor
        label.trailingAnchor --> self.trailingAnchor
        label.bottomAnchor --> self.bottomAnchor
    }
}
