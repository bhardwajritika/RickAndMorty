//
//  RMLocationViewViewModel.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 18/12/25.
//

import Foundation
import UIKit

final class RMLocationViewViewModel {
    
    private var locations: [RMLocation] = []
    
    // Location response info
    // will contain next url if present
    
    private var cellViewModels: [String] = []
    init() {
        
    }
    
    public func fetchLocations() {
        RMService.shared.execute(.listLocationsRequests, expecting: String.self) {
            result in
            switch result {
            case .success(let model):
                break
            case .failure(let error):
                break
            }
        }
    }
    
    private var hasMoreresults: Bool {
        return false
    }
}
