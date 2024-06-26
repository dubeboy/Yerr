//
//  FeedDetailViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/17.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

final class FeedDetailViewController: UICollectionViewController {
    
    var presenter: FeedDetailPresenter!
    @LateInit
    var commentBox: CommentBoxView
    var commentsBoxBottomConstraint: NSLayoutConstraint?
    weak var coordinator: Coordinator!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        commentBox = CommentBoxView()
        setUpCommentBox(commentBox: commentBox)
        navigationItem.title = presenter.title
        presenter.fetchComments(page: 0) { [weak self] commentsCount in
            guard commentsCount > 0 else {
                // Display the no comments banner
                return
            }
            // Do batch updates
            self?.collectionView.reloadData()
        } failuire: { errorMessage in
            self.presentToast(message: errorMessage)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(close))
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapOnReplyButton(_ sender: UIButton) {
        let reply = commentBox.commentText()
        presenter.postComment(comment: reply) { [weak self] comment in
            guard let self = self else { return }
            self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .bottom, animated: false)

            self.collectionView.performBatchUpdates {
                self.collectionView.insertItems(at: [IndexPath(row: 1, section: 0)])
            } completion: { _ in }
            
            
        } error: { errorMessage in
            self.presentToast(message: errorMessage)
        }
    }
    
    @objc func didTapOnSelectedPhotosButton(_ sender: UIButton) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listenToEvent(
            name: .keyboardWillShow,
            selector: #selector(keyboardWillAppear(notification:))
        )
        
        listenToEvent(
            name: .keyboardWillHide,
            selector: #selector(keyboardWillHide(notification:))
        )
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.contentInset.bottom = commentBox.frame.height

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeSelfFromNotificationObserver()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        // TODO: add some nice animation curve here
        commentsBoxBottomConstraint?.constant = 0
    }
    
    @objc func keyboardWillAppear(notification: NSNotification) {
        guard let frame = keyboardFrame(from: notification) else { return }
        print(frame)
        commentsBoxBottomConstraint?.constant = (frame.size.height - spookyKeyboardHeightConstant) * -1
    }
}

extension FeedDetailViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.commentsCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.deque(CommentCollectionViewCell.self, at: indexPath)
        presenter.configure(cell, for: indexPath)
        return cell
    }
}

// MARK: private methods
private extension FeedDetailViewController {
    private func configureCollectionView() {
        collectionView.register(CommentCollectionViewCell.self)
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.scrollDirection = .vertical
        let width = collectionView.bounds.width - (layout.sectionInset.left + layout.sectionInset.right)
        layout.estimatedItemSize = CGSize(width: width, height: 100)
        layout.minimumLineSpacing = 1
        collectionView.backgroundColor = Const.Color.backgroundColor
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setUpCommentBox(commentBox: CommentBoxView) {
        view.addSubview(commentBox)
        commentsBoxBottomConstraint = commentBox.bottomAnchor --> view.safeAreaLayoutGuide.bottomAnchor
        commentBox.leadingAnchor --> view.safeAreaLayoutGuide.leadingAnchor
        commentBox.trailingAnchor --> view.safeAreaLayoutGuide.trailingAnchor
        
        commentBox.replyButton.addTarget(self, action: #selector(didTapOnReplyButton(_:)), for: .touchUpInside)
        commentBox.selectPhotosButton.addTarget(self, action: #selector(didTapOnSelectedPhotosButton(_:)), for: .touchUpInside)
    }
    
    
}
