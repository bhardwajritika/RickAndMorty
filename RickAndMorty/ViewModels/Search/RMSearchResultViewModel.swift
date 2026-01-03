//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 03/01/26.
//

import Foundation


enum RMSearchResultViewModel {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
