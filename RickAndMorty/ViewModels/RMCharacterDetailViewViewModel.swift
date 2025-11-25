//
//  RMCharacterDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 26/11/25.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        character.name.uppercased()
    }
}
