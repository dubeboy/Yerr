//
//  ViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/02.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {
  
    var presenter: FeedPresenter!
    var isPresenting: Bool!
    var interestName: String?
    var introCoordinator: InitScreensCoordinator! // TODO: why is this not weak??
    weak var coordinator: (PostStatusCoordinator & FeedDetailCoordinator)!
    private var indexOfCellBeforeDragging: Int  = 0
    private let swipeVelocityThreshold: CGFloat = 0.5
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Feed"
        presenter.didCompleteSetup { [self] in
            configureSelf()
        } notComplete: { [self] in
            launchSetup()
        }
    }
            
    @objc func postButtonAction(_ sender: Any) {
        coordinator.startPostStatusViewController { statusViewModel in
            self.collectionView.setContentOffset(.zero, animated: false)
            self.collectionView.performBatchUpdates {
                self.presenter.addNewStatus(statusViewModel)
                self.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
            } completion: { _ in }
        }
    }
}

extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.statusCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let status = presenter.getStatus(at: indexPath)
        let cell = collectionView.deque(FeedCollectionViewCell.self, at: indexPath)
        presenter.feedCellPresenter.configure(with: cell,
                                                    forDisplaying: status)
        presenter.feedCellPresenter.setLikeAndVoteButtonsActions(for: cell) { [weak self] in
            self?.presenter.didTapLikeButton(at: indexPath)
        } didTapDownVoteButton: { [weak self] in
            self?.presenter.didTapDownVoteButton(at: indexPath)
        } didTapUpVoteButton: { [weak self] in
            self?.presenter.didTapUpVoteButton(at: indexPath)
        }
        
        return cell
    }
}

extension FeedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // this should be started from the presenter
        coordinator.startFeedDetailViewController(feedViewModel: presenter.getStatus(at: indexPath))
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = indexOfMajorCell()
    }
    // https://medium.com/umake/making-animations-fun-again-838c60418598
    // https://medium.com/@shaibalassiano/tutorial-horizontal-uicollectionview-with-paging-9421b479ee94
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        let indexOfMajorCell = self.indexOfMajorCell()
    
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1
                                                    < presenter.statusCount && velocity.y
                                                    > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1
                                                        >= 0 && velocity.y < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        if didUseSwipeToSkipCell {
//            decay animation
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = (flowLayout.itemSize.height * CGFloat(snapToIndex)) - 16
            // Damping equal 1 => no oscillations => decay animation:
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.y, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: 0, y: toValue)
                scrollView.layoutIfNeeded()
            }, completion: nil)
            
        } else {
            let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
    
            collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: true)
        }
    }
    
}

// MARK: Private Helper functions
private extension FeedViewController {
    
    private func configureCollectionView() {
        collectionView.backgroundColor = Const.Color.backgroundColor
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets(top: Const.View.m8,
                                               left: Const.View.m8,
                                               bottom: Const.View.m8,
                                               right: Const.View.m8)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .vertical
        collectionView.collectionViewLayout = flowLayout
        collectionView.showsVerticalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .automatic
        
        
        let leftRightInset = flowLayout.sectionInset.right + flowLayout.sectionInset.left
        let itemWidth = UIScreen.main.bounds.width - leftRightInset
        let itemHeight =  view.bounds.height
            - flowLayout.sectionInset.top
            - flowLayout.sectionInset.bottom
            - 80 // Peaking
            - (tabBarController?.tabBar.frame.height ?? 0)
            - (navigationController?.navigationBar.frame.size.height ?? 0)
        
        let itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        flowLayout.itemSize = itemSize
        collectionView.register(FeedCollectionViewCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func configureSelf() {
        configureCollectionView()
        presenter.getStatuses(interestName: interestName) { [weak self] count, error in
            guard let self = self else { return }
            
            guard let _ = count else {
                self.presentToast(message: .error(error))
                return
            }
            
            self.collectionView.reloadData()
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(postButtonAction))
    }
    
    private func launchSetup() {
        introCoordinator.start()
    }
    
    private func indexOfMajorCell() -> Int {
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return 0 }
        let itemHeight = flowLayout.itemSize.height
        let proportionalOffset = collectionView.contentOffset.y / itemHeight
        
        let index = Int(round(proportionalOffset))
        let safeIndex = max(0, min(presenter.statusCount - 1, index))
        
        return safeIndex
    }
}

extension FeedViewController: SetupCompleteDelegate {
    func didCompleteSetup() {
        presenter.setupComplete {
            self.configureSelf()
        }
    }
}
