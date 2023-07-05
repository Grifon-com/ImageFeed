//
//  GreenViewController.swift
//  ImageFeed
//
//  Created by Марина Машук on 1.07.23.
//


import UIKit

final class GreenViewController: UIViewController {
    
    private var vc = UIViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green

    }
    
    
    @IBAction func buttonDidSegue(_ sender: UIButton) {
        let notCenter = NotificationCenter.default
        
        notCenter.post(name: NSNotification.Name("Red"), object: nil)
        
        present(vc, animated: true)
    }
}
