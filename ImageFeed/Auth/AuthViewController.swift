//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 22.06.23.
//

import UIKit

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}

final class AuthViewController: UIViewController{
    private let showWebSegueIdentifier = "ShowWebView"
    private var oAuth2Service: OAuth2ServiceProtocol?
    
    weak var delegate: AuthViewControllerDelegate?
    
    private var imageView: UIImageView = {
        let image = UIImage(named: "Logo_of_Unsplash")
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private var logoutButton: UIButton = {
        let logoutButton = UIButton()
        logoutButton.backgroundColor = .ypWhite
        logoutButton.layer.cornerRadius = 16
        logoutButton.layer.masksToBounds = true
        logoutButton.setTitle("Войти", for: .normal)
        logoutButton.setTitleColor(.ypBlack, for: .normal)
        logoutButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
        logoutButton.tintColor = .ypWhite
        logoutButton.addTarget(nil, action: #selector(didTapPushVc), for: .touchUpInside)
        
        return logoutButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oAuth2Service = OAuth2Service()
        view.backgroundColor = .ypBlack
        
        setupUIElement()
        applyConstraint()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @objc private func didTapPushVc() {
        let webVc = WebViewViewController()
        webVc.delegate = self
        webVc.modalPresentationStyle = .fullScreen
        self.present(webVc, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController
            else { return }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

//MARK: - Delegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

//MARK: - Setup UIElement
private extension AuthViewController {
    private func setupUIElement() {
        [imageView, logoutButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func applyConstraint() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logoutButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -90),
            logoutButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            logoutButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            logoutButton.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}
