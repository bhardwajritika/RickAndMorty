//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 24/12/25.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
    func rmSearchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation)

}

final class RMSearchView: UIView {
    
    weak var delegate: RMSearchViewDelegate?
    
    private let viewModel: RMSearchViewViewModel
    
    // MARK: - Subviews
    
    // SearchInputView(bar , selection buttons)
    private let searchInputView = RMSearchInputView()
    
    // No results view
    private let noResultsView = RMNoSearchResultsView()
    
    // Results collectionView
    private let resultView = RMSearchResultsView()
    
    // MARK: - Init
    
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(noResultsView, searchInputView, resultView)
        addConstraints()
        
        searchInputView.configure(with: RMSearchInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self
        
        setUpHandlers(viewModel: viewModel)
        
        resultView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpHandlers(viewModel: RMSearchViewViewModel) {
        viewModel.registerOptionChangeBlock{
            tuple in
            // Tuple: Option | newValue
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }
        
        viewModel.registerSearchResultHandler { [weak self]
            results in
            DispatchQueue.main.async {
                self?.resultView.configure(with: results)
                self?.noResultsView.isHidden = true
                self?.resultView.isHidden = false
            }
        }
        
        viewModel.registerNoResultsHandler { [weak self] in
            DispatchQueue.main.async {
                self?.noResultsView.isHidden = false
                self?.resultView.isHidden = true
            }
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            // Search Input View
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),
            
            // result view
            resultView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            resultView.leftAnchor.constraint(equalTo: leftAnchor),
            resultView.rightAnchor.constraint(equalTo: rightAnchor),
            resultView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            
            // no results
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    public func presentKeyboard() {
        searchInputView.presentKeyboard()
    }

}


// MARK: - CollectionView

extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - RMSearchInputViewDelegate

extension RMSearchView: RMSearchInputViewDelegate {
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }
    
    func rmSearchInputViewDidTapSearchKeyButton(_ inputView: RMSearchInputView) {
        viewModel.executeSearch()
    }
}

extension RMSearchView: RMSearchResultsViewDelegate {
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int) {
        
        guard let locationModel = viewModel.locationSearchResult(at: index) else { return }
        print(index)
        delegate?.rmSearchView(self, didSelectLocation: locationModel)
        print("+++++++++++++++++++++++++++++++++++++++++++++++")
        print(locationModel)
    }
}
