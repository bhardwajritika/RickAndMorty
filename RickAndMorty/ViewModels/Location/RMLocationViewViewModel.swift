//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 18/12/25.
//

import Foundation
import UIKit

protocol RMLocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class RMLocationViewViewModel {
    
    weak var delegate: RMLocationViewViewModelDelegate?
    
    
    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    // Location response info
    // will contain next url if present
    
    private var apiInfo: RMGetLocationsResponse.Info?
    
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
    public var isLoadingMoreLocations = false
    
    private var didFinishPagination: (() -> Void)?
    
    // MARK: - Init
    
    init() {
        
    }
    
    public func registerDidFinishPaginationBlock(_ block : @escaping () -> Void) {
        self.didFinishPagination = block
    }
    
    /// Paginate if additional Locations are needed
    public func fetchAdditionalLocations () {
        guard !isLoadingMoreLocations else {
            return
        }
        
        guard let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else { return }
        
        isLoadingMoreLocations = true
        
        
        guard let request = RMRequest(url: url) else {
            isLoadingMoreLocations = false
            return
        }
        
        RMService.shared.execute(request,
                                 expecting: RMGetLocationsResponse.self) { [weak self] result in
            guard let self = self else {
                return
            }
            print("before request")
            switch result {
            case .success(let responseModel):
                print("after success")
                let moreResults = responseModel.results
                let info = responseModel.info
                
                DispatchQueue.main.async {
                                self.apiInfo = info
                                self.locations.append(contentsOf: moreResults)
                                self.isLoadingMoreLocations = false
                    
                    // Notify via callBack
                                self.delegate?.didFetchInitialLocations()
                                self.didFinishPagination?()
                            }

                
                print(moreResults.count)
//                let originalCount = strongSelf.location.count
//                let newCount = moreResults.count
//                let totalCount = originalCount + newCount
//                let startingIndex = totalCount - newCount
//                let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
//                    return IndexPath(item: $0, section: 0)
//                })
//                print(indexPathToAdd.count)
//                strongSelf.locations.append(contentsOf: moreResults)
//                strongSelf.apiInfo = info
//                print("ViewModels: \(strongSelf.cellViewModels.count)")
//                DispatchQueue.main.async {
//                    print("post-update: \(strongSelf.cellViewModels.count)")
//                    strongSelf.delegate?.didLoadMoreEpisodes(with: indexPathToAdd)
//                     strongSelf.isLoadingMoreEpisodes = false
//                    print("post-update: \(strongSelf.cellViewModels.count)")
//                }
            case .failure(let error):
                print(String(describing: error))
                self.isLoadingMoreLocations = false
            }
            
        }
    }
    
    public func location(at index: Int) -> RMLocation? {
        guard index < locations.count, index >= 0 else {
            return nil
        }
        return self.locations[index]
    }
    
    public func fetchLocations() {
        RMService.shared.execute(.listLocationsRequests, expecting: RMGetLocationsResponse.self) {
            [weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let error):
                break
            }
        }
    }
    
    private var hasMoreresults: Bool {
        return false
    }
}
