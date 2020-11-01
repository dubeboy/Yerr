//
//  InitCountryListsViewController.swift
//  Aweh
//
//  Created by Divine.Dube on 2020/10/31.
//  Copyright © 2020 com.github.aweh. All rights reserved.
//

import UIKit

class InitCountryListsViewController: UIViewController {
    
    var presenter: InitCountryListsPresenter!
    weak var coordinator: InitScreensCoordinator!
    @LateInit
    var collectionView: UICollectionView
    var didSelect: ((CountryViewModel) -> Void)!
    
    var searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        congfigureSelf()
    }
    
   
  
}

extension InitCountryListsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let countryCell = collectionView.deque(CountryCell.self, at: indexPath)
        presenter.configureCell(countryCell, indexPath: indexPath)
        return countryCell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       let country = presenter.didSelectItem(at: indexPath)
        self.dismiss(animated: true) { [self] in
            didSelect(country)
        }
    }
}

extension InitCountryListsViewController {
    
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 60)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
        collectionView --> view
        collectionView.backgroundColor = .clear
    }
    
    private func congfigureSelf() {
        collectionView.registerClass(CountryCell.self)
        view.backgroundColor = .white
        title = presenter.title
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
}

extension InitCountryListsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        presenter.filterCountryByName(searchController.searchBar.text)
        self.collectionView.performBatchUpdates({
            let indexSet = IndexSet(integersIn: 0...0)
            self.collectionView.reloadSections(indexSet)
        }, completion: nil)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("Hello there")
    }
}



extension InitCountryListsViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.resetViewModelState()
        self.collectionView.performBatchUpdates({
            let indexSet = IndexSet(integersIn: 0...0)
            self.collectionView.reloadSections(indexSet)
        }, completion: nil)
    }

}

extension InitCountryListsViewController: UISearchDisplayDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("did begin")
    }
}
