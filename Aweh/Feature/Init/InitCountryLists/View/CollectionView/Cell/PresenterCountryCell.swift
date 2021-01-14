//
//  PresenterCountryCell.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/31.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation


class PresenterCountryCell {
    func configureCell(with model: CountryViewModel, cell: CountryCell) {
        cell.setCountryPhoneNumberExtension(ext: model.phoneExtension, countryName: model.name)
    }
}
