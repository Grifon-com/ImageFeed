//
//  RedViewController.swift
//  ImageFeed
//
//  Created by Марина Машук on 1.07.23.
//

import UIKit

enum Keys {
    static let vcRedIdentifier = "redViewController"
    static let vcGreenIdentifier = "greenViewController"
    static let segueIdentifier = "ShowGreenViewCotroller"
}

final class RedViewController: UIViewController {
    private var segue: UIStoryboardSegue?
    private var navigVc: UINavigationController?
    
    
    @IBOutlet weak var buttonView: UIButton!
    
    var count = 0
    
    
    private var label: UILabel = {
        let label = UILabel()
        label.text = "Hi"
        label.textColor = .ypGrey
        label.font = UIFont.systemFont(ofSize: 28)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypRed
        view.addSubview(buttonView)
        view.addSubview(label)
        setupElement()
        let storybord = UIStoryboard(name: "Main", bundle: .main)
        let greenVc = storybord.instantiateViewController(identifier: Keys.vcGreenIdentifier)
        let redVc = storybord.instantiateViewController(withIdentifier: Keys.vcRedIdentifier)

        
        segue = UIStoryboardSegue(identifier: "ShowGreenViewController", source: redVc, destination: greenVc)
        
        NotificationCenter.default.addObserver(self, selector: #selector(nsFunc), name: .nameCount, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(nsButton), name: .nameButton, object: nil)

    }
    
    @objc private func nsFunc() {
       count += 1
        label.text = "\(count)"
    }
    
    @objc private func nsButton() {
        buttonView.titleLabel?.text = "\(count)"
    }
    
    @IBAction func didTapButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: .nameCount, object: nil)
        if count == 3 {
            NotificationCenter.default.post(name: .nameButton, object: nil)
        }
    }
    
    private func setupElement() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

