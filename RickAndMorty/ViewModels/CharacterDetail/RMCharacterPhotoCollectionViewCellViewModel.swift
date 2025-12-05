//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 04/12/25.
//

import UIKit

final class RMCharacterPhotoCollectionViewCellViewModel {
    private let imageURL: URL?
    
    init(imageURL: URL?) {
        self.imageURL = imageURL
    }
    
    public func fetchImage(completion: @escaping (Result <Data, Error>) -> Void) {
        guard let imageURL = imageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageLoader.shared.downloadImage( imageURL, completion: completion)
    }
}
