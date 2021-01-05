//
//  VideoViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/12/12.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

// TODO: delete please
class VideoViewController: UIViewController {
    
    private var videoView: StatusVideoView = StatusVideoView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureSelf()
    }
    
    
}

private extension VideoViewController {
    func configureSelf() {
        view.addSubview(videoView)
        videoView.autoresizingOff()
        videoView --> view
//        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Text", style: .plain, target: self, action: #selector(addTextToVideo))] // should change to text
    }
}
