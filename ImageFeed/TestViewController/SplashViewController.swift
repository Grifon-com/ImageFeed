//
//  UIscreen.swift
//  ImageFeed
//
//  Created by Марина Машук on 5.07.23.
//

import UIKit

final class SplashViewController: UIViewController {
    private var token: TokenStorage?
    
    
    
    override func viewDidLoad() {
        token = TokenStorage()
        
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let redVc = storyboard.instantiateViewController(identifier: Keys.vcRedIdentifier)
        let grrenVc = storyboard.instantiateViewController(identifier: Keys.vcGreenIdentifier)
        
        let segue = UIStoryboardSegue(identifier: Keys.segueIdentifier, source: redVc, destination: grrenVc)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let token = token?.token {
            
        } else {
            performSegue(withIdentifier: Keys.segueIdentifier, sender: nil)
        }
    }
}
