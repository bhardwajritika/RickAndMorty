//
//  RMTableLoadingFooterView.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 05/01/26.
//

import UIKit

final class RMTableLoadingFooterView: UIView {
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews(spinner)
        spinner.startAnimating()
        
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            spinner.widthAnchor.constraint(equalToConstant: 55),
            spinner.heightAnchor.constraint(equalToConstant: 55),
            
            self.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            self.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

}
