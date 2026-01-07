//
//  RMSearchResultViewType.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 03/01/26.
//

import Foundation

final class RMSearchResultViewModel {
    public private(set) var results: RMSearchResultViewType
    private var next: String?
    public private(set) var isLoadingMoreResults = false
    
    init(results: RMSearchResultViewType, next: String?) {
        self.results = results
        self.next = next
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return next != nil
    }
    
    public func fetchAdditionalLocations(completion: @escaping ([RMLocationTableViewCellViewModel]) -> Void) {
        guard !isLoadingMoreResults else { return}
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else { return }
        
        isLoadingMoreResults = true
    
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }
        
        RMService.shared.execute(request,
                                 expecting: RMGetLocationsResponse.self) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                
                DispatchQueue.main.async {
                    self.next = info.next // Capture new pagination urls
                    
                    let additionalLocations = moreResults.compactMap({
                        return RMLocationTableViewCellViewModel(location: $0)
                    })
                    var newResults : [RMLocationTableViewCellViewModel] = []
                    switch self.results {
                    case .characters, .episodes:
                        break
                    case .locations(let existingResults):
                        newResults = existingResults + additionalLocations
                        self.results = .locations(newResults)
                    }
                    
                    self.isLoadingMoreResults = false
                    
                    // Notify via callBack
                    completion(newResults)
//                    self.delegate?.didFetchInitialLocations()
//                    self.didFinishPagination?()
                }

            case .failure(let error):
                print(String(describing: error))
                self.isLoadingMoreResults = false
            }
        }
    }
}


enum RMSearchResultViewType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
