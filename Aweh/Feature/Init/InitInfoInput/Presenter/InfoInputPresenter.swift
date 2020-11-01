//
//  InfoInputPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/24.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol InfoInputPresenter {
    var namePlaceHolder: String { get }
    var handleFieldPlaceHolder: String { get }
    var title: String { get }
    var doneButtonTitle: String { get }
}

class InfoInputPresenterImplementation: InfoInputPresenter {
    var doneButtonTitle: String = AppStrings.InfoInput.doneButtonTitle

    var title: String = AppStrings.InfoInput.title
    
    var namePlaceHolder: String = AppStrings.InfoInput.namePlaceHolder
    var handleFieldPlaceHolder: String =  AppStrings.InfoInput.handlePlaceHolder
}
