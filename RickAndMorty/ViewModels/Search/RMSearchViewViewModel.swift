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
    
    private var searchResultHandler: ((RMSearchResultViewModel) -> Void)?
    
    private var noResultsHandler: (() -> Void)?
    
    private var searchResultModel: Codable?
    
    private var locationResults: [RMLocation] = []
    
    // MARK: - Init
    
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
    
    // MARK: - Public
    
    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) {
        self.searchResultHandler = block
    }
    
    public func registerNoResultsHandler(_ block: @escaping () -> Void) {
        self.noResultsHandler = block
    }
    
    public func executeSearch() {
        // Create Request based on filters
        // https://rickandmortyapi.com/api/character/?name=rick&status=alive
        
        // Send API Call
        
        print(searchText)
        
        // Build arguments
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
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
        
        switch config.type.endpoint {
        case .character:
            return makeSearchAPICall(RMGetAllCharacterResponse.self, request: request)
        case .location:
            return makeSearchAPICall(RMGetLocationsResponse.self, request: request)
        case .episode:
            return makeSearchAPICall(RMGetAllEpisodeResponse.self, request: request)
        }
    }
    
    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request:RMRequest) {
        // Execute the request
        RMService.shared.execute(request, expecting: type) {
            
            // Notify view of results, no results, or error
            [weak self] result in
            switch result {
            case .success(let model):
                // Episodes and charcaters : CollectionView
                // Location: TableView
                self?.processSearchResults(model: model)
            case .failure:
                self?.handleNoResults()
            }
        }
    }
    
    private func processSearchResults(model: Codable) {
        var resultsVM: RMSearchResultViewModel?
        if let characterResults = model as? RMGetAllCharacterResponse {
            resultsVM = .characters(characterResults.results.compactMap({
                return RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageURL: URL(string: $0.image)
                )
            }))
        }
        else if let episodesResults = model as? RMGetAllEpisodeResponse {
            resultsVM = .episodes(episodesResults.results.compactMap({
                return RMCharacterEpisodeCollectionViewCellViewModel(
                    episodeDataUrl: URL(string:$0.url)
                )
            }))
        }
        else if let locationsResults = model as? RMGetLocationsResponse {
            self.locationResults = locationsResults.results
            resultsVM = .locations(locationsResults.results.compactMap({
                return RMLocationTableViewCellViewModel(location: $0)
            }))
        }
        if let results = resultsVM {
            self.searchResultModel = model
            self.searchResultHandler?(results)
        } else {
            // fallBack error
            handleNoResults()
        }
    }
    
    private func handleNoResults() {
        print("No results")
        noResultsHandler?()
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
    
    public func locationSearchResult(at index : Int) -> RMLocation? {
        guard index < locationResults.count else { return nil }
        return locationResults[index]
    }
}
