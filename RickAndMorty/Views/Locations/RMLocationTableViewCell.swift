//
//  RMLocationTableViewCell.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 21/12/25.
//

import UIKit

final class RMLocationTableViewCell: UITableViewCell {
    static let cellIdentifier = "RMLocationtableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    public func configure(with viewModel: RMLocationTableViewCellViewModel) {
        
    }
}
