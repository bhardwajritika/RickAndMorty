//
//  RMEpisodeDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 11/12/25.
//

import UIKit

class RMEpisodeDetailViewViewModel {

    private let endpointUrl: URL?
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        fetchEpisodeData()
    }
    private func fetchEpisodeData() {
        guard let url = endpointUrl,
                let request = RMRequest(url: url) else { return }
        
        RMService.shared.execute(request, expecting: RMEpisode.self) {
            result in
            
            switch result {
            case .success(let success):
                print(String(describing: success))
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }

}

