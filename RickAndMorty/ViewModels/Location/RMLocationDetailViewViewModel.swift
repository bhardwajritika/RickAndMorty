//
//  RMLocationDetailViewViewModel.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 22/12/25.
//

import UIKit

protocol RMLocationDetailViewViewModelDelegate : AnyObject {
    func didFetchLocationDetails()
}

final class RMLocationDetailViewViewModel {

    private let endpointUrl: URL?
    
    private var dataTuple: (location: RMLocation, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchLocationDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModel: [RMCharacterCollectionViewCellViewModel])
    }

    
    public weak var delegate: RMLocationDetailViewViewModelDelegate?
    
    public private(set) var cellViewModels: [SectionType] = [] // public just for reading
    
        
    // MARK: - Init
    
    init(endpointUrl: URL?) {
        self.endpointUrl = endpointUrl
        
    }
    
    
    // MARK: - Public
    
    public func character(at index: Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else {
            return nil
        }
        return dataTuple.characters[index]
    }
    
    /// Fetch backing location model
    public func fetchLocationData() {
        guard let url = endpointUrl,
                let request = RMRequest(url: url) else { return }
        
        RMService.shared.execute(request, expecting: RMLocation.self) {
            [weak self] result in
            
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(location: model)
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    // MARK: - Private
    
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else { return }
        let location = dataTuple.location
        let characters = dataTuple.characters
        
        var createdString = ""
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: location.created) {
            createdString = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }
        cellViewModels = [
        .information(viewModels: [
            .init(title: "Location Name", value: location.name),
            .init(title: "Type", value: location.type),
            .init(title: "Dimension", value: location.dimension),
            .init(title: "Created", value: createdString)
            ]),
        .characters(viewModel: characters.compactMap({ character in
            return RMCharacterCollectionViewCellViewModel(
                characterName: character.name,
                characterStatus: character.status,
                characterImageURL: URL(string: character.image))
        }))
    ]
    }
    
    private func fetchRelatedCharacters(location: RMLocation) {
        let characterUrls: [URL] = location.residents.compactMap ({
            return URL(string: $0) })
        
        let requests: [RMRequest] = characterUrls.compactMap({
            return RMRequest(url: $0)
        })
 
        
        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        for request in requests {
            group.enter() // +1 increment the operation
            RMService.shared.execute(request, expecting: RMCharacter.self) {
                result in
                
                defer {
                    group.leave() // for decrement
                }
                
                switch result {
                    case .success(let model):
                    characters.append(model)
                    case .failure:
                        break
                }
            }
        }
        
        group.notify(queue: .main) {
            self.dataTuple = (
                location: location,
                characters: characters
            )
        }
    }
    

}


