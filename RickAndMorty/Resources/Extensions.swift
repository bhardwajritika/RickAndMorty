//
//  Extensions.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 25/11/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { addSubview($0) }
    }
}
