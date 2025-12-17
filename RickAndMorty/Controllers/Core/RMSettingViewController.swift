//
//  RMSettingViewController.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 22/11/25.
//
import SafariServices
import SwiftUI
import UIKit

/// Controller to show various app options and settings
final class RMSettingViewController: UIViewController {
    
    private var settingsSwiftUIController: UIHostingController<RMSettingsView>?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"
        addSwiftUIController()
    }
    
    private func addSwiftUIController() {
        let hostingController = UIHostingController(
            rootView: RMSettingsView(
                viewModel: RMSettingsViewViewModel(
                    cellViewModel: RMSettingsOption.allCases.compactMap ({
                        return RMSettingsCellViewModel(type: $0) {
                           [weak self] option in
                            self?.handleTap(option: option)
                            
                        }
                    })
                )
            )
        )
        
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        self.settingsSwiftUIController = hostingController
    }
    
    private func handleTap(option: RMSettingsOption) {
        guard Thread.current.isMainThread else {
            return
        }
        
        if let url = option.targetUrl {
            // Open the website
            let vc = SFSafariViewController(url: url)
            present(vc, animated : true)
        }
        else if option == .rateApp {
            // Show rating prompt
        }
    }
}
