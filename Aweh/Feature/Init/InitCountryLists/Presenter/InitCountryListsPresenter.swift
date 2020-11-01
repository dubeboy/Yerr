//
//  InitCountryListsPresenter.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/31.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import Foundation

protocol InitCountryListsPresenter {
    func configureCell(_ cell: CountryCell, indexPath: IndexPath)
    var numberOfItems: Int { get }
    var title: String { get }
    func filterCountryByName(_ name: String?)
    func resetViewModelState()
    var isStillSearching: Bool { get }
    var currentSearchText: String { get }
    func didSelectItem(at index: IndexPath) -> CountryViewModel
}

struct InitCountryViewModel {
    var countries = CountryViewModel.countries
    var currentText = ""
}

class InitCountryListsPresenterImplementation: InitCountryListsPresenter {
    func didSelectItem(at index: IndexPath) -> CountryViewModel {
        return viewModel.countries[index.item]
    }
    
    var title: String = AppStrings.InitCoutryLists.title
    
    var viewModel: InitCountryViewModel = InitCountryViewModel()
    let cellPresenter = PresenterCountryCell()
    
    var numberOfItems: Int {
        viewModel.countries.count
    }
    
    
    func configureCell(_ cell: CountryCell, indexPath: IndexPath) {
        let country = viewModel.countries[indexPath.item]
        cellPresenter.configureCell(with: country, cell: cell)
    }
    
    func filterCountryByName(_ name: String?) {
        guard let name = name, !name.isEmpty else { return }
        viewModel.currentText = name
        viewModel.countries = CountryViewModel.countries.filter { country in
            country.name.contains(name)
       }
    }
    
    func resetViewModelState() {
        viewModel.countries = CountryViewModel.countries
        viewModel.currentText = ""
    }
    
    var isStillSearching: Bool {
        !viewModel.currentText.isEmpty
    }
    
    var currentSearchText: String {
        viewModel.currentText
    }
}
