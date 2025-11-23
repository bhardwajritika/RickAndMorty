//
//  RMCharaterViewController.swift
//  RickAndMorty
//
//  Created by Tarun Sharma on 22/11/25.
//

import UIKit


/// Controller to show and search for Characters
final class RMCharacterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        title = "Characters"
        
        let request = RMRequest(
            endpoint: .character,
            pathComponents: ["1"]
        )
        print(request.url!)
        
        RMService.shared.execute(request,
                                 expecting: String.self) {
        }
        
    }


}
