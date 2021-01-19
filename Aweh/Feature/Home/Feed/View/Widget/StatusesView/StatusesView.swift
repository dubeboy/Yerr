//
//  StatusesStackView.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/11/21.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class StatusesView: UIView {
    
    var statusText = UILabel()
    var mediaStatus = UILabel()
    
    @LateInit
    private var statusIndicatorView: StatusIndicator
    
    private var statusesCollectionView: UICollectionView
    var viewModel: StatusPageViewModel?
    
    init() {
        viewModel = nil
        statusesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        super.init(frame: .zero)
        statusIndicatorView = StatusIndicator(delegate: self)
        configureSelf()
        configureCollectionView()
        configureStatusText()
        configureIndicatorView()
    }
    
    func setViewModel(viewModel: StatusPageViewModel) {
        self.viewModel = viewModel
        if viewModel.media.isEmpty {
            showStatusText()
            statusText.text = viewModel.status // TODO: should probably be attributed text
            statusIndicatorView.setItemCount(itemCount: viewModel.media.count)
        } else {
            showStatusesCollectionView()
            statusesCollectionView.reloadData()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let flowLayout = statusesCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.itemSize = bounds.size
        flowLayout.scrollDirection = .horizontal
    }
}

extension StatusesView {
    private func configureSelf() {
        
    }
    
    private func showStatusesCollectionView() {
        statusesCollectionView.isHidden = false
        statusText.isHidden = true
        statusIndicatorView.isHidden = false
    }
    
    private func showStatusText() {
        statusesCollectionView.isHidden = true
        statusText.isHidden = false
        statusIndicatorView.isHidden = true
    }
    
    private func configureCollectionView() {
        statusesCollectionView.autoresizingOff()
        statusesCollectionView.delegate = self
        statusesCollectionView.dataSource = self
        addSubview(statusesCollectionView)
        statusesCollectionView --> self
        statusesCollectionView.showsVerticalScrollIndicator = false
        statusesCollectionView.showsHorizontalScrollIndicator = false
        statusesCollectionView.registerClass(StatusCell.self)
        statusesCollectionView.backgroundColor = .clear
    }
    
    private func configureStatusText() {
        statusText.autoresizingOff()
        addSubview(statusText)
        
        statusText.topAnchor --> self.topAnchor
        statusText.leadingAnchor --> self.leadingAnchor + Const.View.m16 * 2
        statusText.trailingAnchor --> self.trailingAnchor + -Const.View.m16 * 2
        statusText.bottomAnchor --> self.bottomAnchor
        
        statusText.textAlignment = .center
        statusText.numberOfLines = 0
        statusText.lineBreakMode = .byWordWrapping
    }
    
    private func configureIndicatorView() {
        statusIndicatorView.autoresizingOff()
        addSubview(statusIndicatorView)
        statusIndicatorView.topAnchor --> self.topAnchor
        statusIndicatorView.leadingAnchor --> self.leadingAnchor
        statusIndicatorView.trailingAnchor --> self.trailingAnchor + -Const.View.m16
        statusIndicatorView.heightAnchor --> 2
    }
}

extension StatusesView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.media.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(StatusCell.self, at: indexPath)
        guard let viewModel = viewModel else { return UICollectionViewCell() }
        let media = viewModel.media[indexPath.item]
        cell.showContent(content: media, statusText: viewModel.status)
        return cell
    }
}

extension StatusesView: UICollectionViewDelegate {
    
}

extension StatusesView: StatusTimoutDelegate {
    func timeout() {
        
    }
}
