//
//  InfoInput.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class InfoInputViewController: UIViewController {
    private var userProfileImageView: UIImageView = UIImageView()
    private var nameTextField = UITextField()
    private var handleField = UITextField()
    private var nameHandleStackView = UIStackView()
    private var editProfileImageButton = YerrButton(frame: .zero)
    
    weak var coordinator: InitScreensCoordinator!
    
    var presenter: InfoInputPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = presenter.title
        view.backgroundColor = .white
        configureSelf()
        configurenameHandleStackView()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: presenter.doneButtonTitle, style: .plain, target: self, action: #selector(done))
        navigationItem.hidesBackButton = true
    }
    
    @objc func done() {
        
    }
}

extension InfoInputViewController {
  
    private func configureSelf() {
        userProfileImageView.autoresizingOff()
        view.addSubview(userProfileImageView)
        userProfileImageView.leadingAnchor --> view.leadingAnchor + Const.View.m16
        userProfileImageView.widthAnchor --> 60
        userProfileImageView.heightAnchor --> 60
        userProfileImageView.topAnchor --> view.safeAreaLayoutGuide.topAnchor + Const.View.m16
        editProfileImageButton.autoresizingOff()
        userProfileImageView.addSubview(editProfileImageButton)
        editProfileImageButton --> userProfileImageView
        editProfileImageButton.setImage(Const.Assets.InitInfoInput.editButton, for: .normal)
        editProfileImageButton.backgroundColor = Const.Color.lightGray
    }
    
    private func configurenameHandleStackView() {
        nameHandleStackView.autoresizingOff()
        nameHandleStackView.axis = .vertical
        nameHandleStackView.alignment = .fill
        nameHandleStackView.distribution = .fillEqually
        nameHandleStackView.spacing = Const.View.m8
        view.addSubview(nameHandleStackView)
        nameHandleStackView.topAnchor --> userProfileImageView.topAnchor
        nameHandleStackView.leadingAnchor --> userProfileImageView.trailingAnchor + Const.View.m8
        nameHandleStackView.trailingAnchor --> view.trailingAnchor + -Const.View.m16
        
        // TODO: look for a better style than this!1
//        nameTextField.addDividerLine(to: [.bottom])
//        handleField.addDividerLine(to: [.bottom])
        
        nameHandleStackView.addArrangedSubview(nameTextField)
        nameTextField.placeholder = presenter.namePlaceHolder
        nameHandleStackView.addArrangedSubview(handleField)
        handleField.placeholder = presenter.handleFieldPlaceHolder
    }
}
