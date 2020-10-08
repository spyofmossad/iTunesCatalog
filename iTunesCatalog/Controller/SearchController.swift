//
//  SearchController.swift
//  iTunesCatalog
//
//  Created by Dmitry on 07.10.2020.
//

import UIKit

protocol SearchBarDelegate: class {
    func fetchData()
}

class SearchController: UIViewController {
        
    weak var delegate: SearchBarDelegate?
        
    var isLoading: Bool = false
        
    let searchController = UISearchController(searchResultsController: nil)
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSearchController()
        self.definesPresentationContext = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func prepareSearchController() {
        searchController.searchResultsUpdater = self
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
    }
}

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if !searchBarIsEmpty {
            if !isLoading {
                showSpinner()
                isLoading = true
            }
            delegate?.fetchData()
        } else {
            showPlaceholder(with: "Hey, looking for something?")
        }
    }
}
