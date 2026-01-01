//
//  RMSearchViewViewModel.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 24/12/25.
//

import Foundation

// Responsibilities
// - show search result
// - show no request view
// - kick off API request

final class RMSearchViewViewModel {
    let config: RMSearchViewController.Config
    private var optionMap: [RMSearchInputViewViewModel.DynamicOption: String] = [:]
    private var searchText = ""
    
    private var optionMapUpdateBlock: (((RMSearchInputViewViewModel.DynamicOption, String)) -> Void)?
    
    private var searchResultHandler: (() -> Void)?
    
    // MARK: - Init
    
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - Public
    
    public func registerSearchResultHandler(_ block: @escaping () -> Void) {
        self.searchResultHandler = block
    }
    
    public func executeSearch() {
        // Create Request based on filters
        // https://rickandmortyapi.com/api/character/?name=rick&status=alive
        
        // Send API Call
        
        // Test search text
        searchText = "Rick Sanchez"
        
        // Build arguments
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText)
        ]
        
        // Add options
        queryParams.append(contentsOf: optionMap.enumerated().compactMap(
            {
                _ , element in
                let key : RMSearchInputViewViewModel.DynamicOption = element.key
                let value : String = element.value
                return URLQueryItem(name: key.queryArgument , value: value)
            }
        ))
        
        // Create request
        let request = RMRequest(
            endpoint: config.type.endpoint,
            queryParameters: queryParams
        )
        print(request.url?.absoluteString)
        
        // Execute the request
        RMService.shared.execute(request, expecting: RMGetAllCharacterResponse.self) {
            
            // Notify view of results, no results, or error
            result in
            switch result {
            case .success(let model):
                print(model.results.count)
            case .failure(let error):
                break
            }
        }
        
    }
    
    public func set(query text: String) {
        self.searchText = text
    }
    
    public func set(value: String, for option: RMSearchInputViewViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }
    
    public func registerOptionChangeBlock(_ block: @escaping ((RMSearchInputViewViewModel.DynamicOption, String)) -> Void) {
        self.optionMapUpdateBlock = block
    }
}
