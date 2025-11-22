//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 22/11/25.
//

import UIKit

final class RMTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
        
    }
    
    private func setUpTabs() {
        
        let charactersVC = RMCharacterViewController()
        let episodesVC = RMEpisodeViewController()
        let locationsVC = RMLocationViewController()
        let settingsVC = RMSettingViewController()
        
        charactersVC.navigationItem.largeTitleDisplayMode = .automatic
        episodesVC.navigationItem.largeTitleDisplayMode = .automatic
        locationsVC.navigationItem.largeTitleDisplayMode = .automatic
        settingsVC.navigationItem.largeTitleDisplayMode = .automatic
        
        let nav1 = UINavigationController(rootViewController: charactersVC)
        let nav2 = UINavigationController(rootViewController: episodesVC)
        let nav3 = UINavigationController(rootViewController: locationsVC)
        let nav4 = UINavigationController(rootViewController: settingsVC)
        
        nav1.tabBarItem = UITabBarItem(title: "Characters", image: UIImage(systemName: "person.crop.circle"), selectedImage: UIImage(systemName: "person.crop.circle.fill"))
        nav2.tabBarItem = UITabBarItem(title: "Episodes", image: UIImage(systemName: "tv"), selectedImage: UIImage(systemName: "tv.fill"))
        nav3.tabBarItem = UITabBarItem(title: "Locations", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))
        nav4.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), selectedImage: UIImage(systemName: "gear.fill"))
        
        for nav in [nav1, nav2, nav3, nav4] {
            nav.navigationBar.prefersLargeTitles = true
        }
        
        setViewControllers([nav1, nav2, nav3, nav4], animated: true)
        
        
    }


}

