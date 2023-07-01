//
//  RedViewController.swift
//  ImageFeed
//
//  Created by Марина Машук on 1.07.23.
//

import UIKit

final class RedViewController: UIViewController {
    private var segue: UIStoryboardSegue?
    private var navigVc: UINavigationController?
    
    private let buttonView: UIButton = {
        let size = CGSize.init(width: 100, height: 50)
        let origin = CGPoint(x: 100, y: 100)
        let frame = CGRect(origin: origin, size: size)
        let buttonView = UIButton(frame: frame)
        buttonView.titleLabel?.textColor = .ypBackground
        buttonView.setTitle("Переход", for: .normal)
       
        
        return buttonView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypRed
        view.addSubview(buttonView)
        let storybord = UIStoryboard(name: "Main", bundle: .main)
        let greenVc = storybord.instantiateViewController(identifier: "greenViewController")
        let redVc = storybord.instantiateViewController(withIdentifier: "redViewController")

        buttonView.addTarget(RedViewController.self, action: #selector(didShowGreenVc), for: .touchUpInside)
        
        segue = UIStoryboardSegue(identifier: "ShowGreenViewController", source: redVc, destination: greenVc)
        
        
    }
    
    @objc private func didShowGreenVc(_ sender: UIButton) {
        if segue?.identifier == "ShowGreenViewController" {
            if  let vc = segue?.destination as? GreenViewController  {
                self.present(vc, animated: true)
            }}
    }
}

