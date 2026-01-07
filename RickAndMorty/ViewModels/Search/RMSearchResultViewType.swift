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
    
    public func fetchAdditionalResults(completion: @escaping ([any Hashable]) -> Void) {
        guard !isLoadingMoreResults else { return}
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString) else { return }
        
        isLoadingMoreResults = true
    
        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }
        
        switch results {
        case .characters(let existingResults):
            
            RMService.shared.execute(request,
                                     expecting: RMGetAllCharacterResponse.self) { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    
                    DispatchQueue.main.async {
                        self.next = info.next // Capture new pagination urls
                        
                        let additionalResults = moreResults.compactMap({
                            return RMCharacterCollectionViewCellViewModel(characterName: $0.name,
                                characterStatus: $0.status,
                                characterImageURL: URL(string: $0.image)!
                            )
                        })
                        var newResults : [RMCharacterCollectionViewCellViewModel] = []
                        newResults = existingResults + additionalResults
                        self.results = .characters(newResults)
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
        case .episodes(let existingResults):
            
            RMService.shared.execute(request,
                                     expecting: RMGetAllEpisodeResponse.self) { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    
                    DispatchQueue.main.async {
                        self.next = info.next // Capture new pagination urls
                        
                        let additionalResults = moreResults.compactMap({
                            return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url)!)
                        })
                        var newResults : [RMCharacterEpisodeCollectionViewCellViewModel] = []
                        newResults = existingResults + additionalResults
                        self.results = .episodes(newResults)
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
        case .locations(let array):
            break
        }
        
    }
}


enum RMSearchResultViewType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
