//
//  RMEpisodeListViewViewModel.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 11/12/25.
//

import UIKit

protocol RMEpisodeListViewViewModelDelegate : AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPaths: [IndexPath])
    func didSelectEpisode(_ episode: RMEpisode)
}

/// View Model to handle episode list view logic
final class RMEpisodeListViewViewModel : NSObject {
    
    public weak var delegate: RMEpisodeListViewViewModelDelegate?
    
    private var isLoadingMoreEpisodes: Bool = false
    
    private var episodes: [RMEpisode] = [] {
        didSet {
            for episode in episodes {
                let viewModel = RMCharacterEpisodeCollectionViewCellViewModel( episodeDataUrl: URL(string: episode.url))
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
                
            }
        }
    }
    
    private var cellViewModels : [RMCharacterEpisodeCollectionViewCellViewModel] = []
    
    private var apiInfo: RMGetAllEpisodeResponse.Info? = nil
    /// Fetch initial set of episode (20)
    public func fetchEpisodes () {
        RMService.shared.execute(.listEpisodesRequests,
                                 expecting: RMGetAllEpisodeResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.episodes = results
                self?.apiInfo = info
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisodes()
                }
                
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    /// Paginate if additional episodes are needed
    public func fetchAdditionalEpisodes (url: URL) {
        guard !isLoadingMoreEpisodes else {
            return
        }
        print("fetching more data")
        isLoadingMoreEpisodes = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreEpisodes = false
            return
        }
        
        RMService.shared.execute(request,
                                 expecting: RMGetAllEpisodeResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                print("pre-update: \(strongSelf.cellViewModels.count)")
                let moreResults = responseModel.results
                let info = responseModel.info
                
                let originalCount = strongSelf.episodes.count
                let newCount = moreResults.count
                let totalCount = originalCount + newCount
                let startingIndex = totalCount - newCount
                let indexPathToAdd: [IndexPath] = Array(startingIndex..<(startingIndex+newCount)).compactMap({
                    return IndexPath(item: $0, section: 0)
                })
                print(indexPathToAdd.count)
                strongSelf.episodes.append(contentsOf: moreResults)
                strongSelf.apiInfo = info
                print("ViewModels: \(strongSelf.cellViewModels.count)")
                DispatchQueue.main.async {
                    print("post-update: \(strongSelf.cellViewModels.count)")
                    strongSelf.delegate?.didLoadMoreEpisodes(with: indexPathToAdd)
                     strongSelf.isLoadingMoreEpisodes = false
                    print("post-update: \(strongSelf.cellViewModels.count)")
                }
            case .failure(let error):
                print(String(describing: error))
                self?.isLoadingMoreEpisodes = false
            }
            
        }
    }
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

// MARK: - CollectionView
extension RMEpisodeListViewViewModel : UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier, for: indexPath) as? RMCharacterEpisodeCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        let viewModel = cellViewModels[indexPath.row]
        
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind : String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter ,
                let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
            for: indexPath
        ) as? RMFooterLoadingCollectionReusableView
                 else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width,
                      height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width-30)/2
        return CGSize(
            width: width,
            height: width * 0.8)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let selection = episodes[indexPath.row]
        delegate?.didSelectEpisode(selection)
    }
}

// MARK: - ScrollView
extension RMEpisodeListViewViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator ,
            !isLoadingMoreEpisodes,
              !cellViewModels.isEmpty,
            let nextUrlString = apiInfo?.next,
            let url = URL(string: nextUrlString) else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.fetchAdditionalEpisodes(url: url)
                
            }
            t.invalidate()

        }
    }
    
}

