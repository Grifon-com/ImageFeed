//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Марина Машук on 5.07.23.
//


import UIKit

final class AuthViewController: UIViewController {
    
    private var handler: (() -> Void?)? = nil
    
    let segueIdentifier = "showWebView"
    
    private let imageView: UIImageView = {
        let image = UIImage(named: "Vector")
        let imageView = UIImageView(image: image)
        
        return imageView
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypWhite
        button.clipsToBounds = true
        button.titleLabel?.text = "Login"
        button.titleLabel?.textColor = .ypBlack
        button.layer.cornerRadius = button.frame.size.height / 2
        button.addTarget(AuthViewController.self, action: #selector(didTap), for: .allTouchEvents)
        return button
    }()
    
    @objc func didTap() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
       let greenVc = storyboard.instantiateViewController(identifier: Keys.vcRedIdentifier)
        show(greenVc, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypBlack
        addView()
        setupImageView()
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
       let greenVc = storyboard.instantiateViewController(identifier: Keys.vcGreenIdentifier)
        let segue = UIStoryboardSegue(identifier: segueIdentifier, source: self, destination: greenVc)
        
    }
    
    private func addView() {
        [imageView, button].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func setupImageView() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
