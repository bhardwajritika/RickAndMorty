//
//  RMSettingViewController.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 22/11/25.
//

import UIKit

/// Controller to show various app options and settings
final class RMSettingViewController: UIViewController {
    
    private let viewModel = RMSettingsViewViewModel(cellViewModel: RMSettingsOption.allCases.compactMap({
        return RMSettingsCellViewModel(type: $0)
    })
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        
        title = "Settings"
    }

}
