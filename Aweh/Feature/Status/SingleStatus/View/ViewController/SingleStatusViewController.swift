//
//  StatusViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/06/23.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class SingleStatusViewController: UIViewController {
    
    @IBOutlet weak var statusImage: UIImageView! {
        didSet {
            statusImage.contentMode = .scaleAspectFit
        }
    }
    
    @IBOutlet weak var commentBoxConstraint: NSLayoutConstraint!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentDividerLine: UIView!
    
    var presenter: SingleStatusPresenter!
    var coordinator: Coordinator!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getStatus { [weak self] viewModel in
            guard let self = self else { return }
            self.statusLabel.text = viewModel.status.string
            self.statusImage.image = viewModel.statusImage
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.endEditing(true)
        listenToEvent(
            name: .keyboardWillChangeFrame,
            selector: #selector(keyboardWillShow(notification:))
        )
        commentBoxConstraint.constant = 0
    }
    

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.endEditing(true)
        removeSelfFromNotificationObserver()
        commentBoxConstraint.constant = 0
    }
    
    @IBAction func sendButton(_ sender: Any) {
    }
    
    @IBAction func mediaButtom(_ sender: Any) {
        
    }
    @IBAction func commentButton(_ sender: Any) {
        
        
    }
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let frame = keyboardFrame(from: notification) else { return }
        commentBoxConstraint.constant = frame.size.height
    }
}
