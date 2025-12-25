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
    
    init(config: RMSearchViewController.Config) {
        self.config = config
    }
}
