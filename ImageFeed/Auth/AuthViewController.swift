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
    private struct Constants {
        static let imageView = "Logo_of_Unsplash"
        static let buttonTitleLogout = "Войти"
        static let labelTitleLogoutButtonFont = CGFloat(17)
        static let cornerRadiusLogoutButton = CGFloat(16)
    }
    
    private var oAuth2Service: OAuth2ServiceProtocol?
    
    weak var delegate: AuthViewControllerDelegate?
    
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: Constants.imageView)
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = .clear
        
        return imageView
    }()
    
    private lazy var logoutButton: UIButton = {
        let logoutButton = UIButton()
        logoutButton.accessibilityIdentifier = ConstantsImageFeed.authButtonIdentifier
        logoutButton.backgroundColor = .ypWhite
        logoutButton.layer.cornerRadius = Constants.cornerRadiusLogoutButton
        logoutButton.layer.masksToBounds = true
        logoutButton.setTitle(Constants.buttonTitleLogout, for: .normal)
        logoutButton.setTitleColor(.ypBlack, for: .normal)
        logoutButton.titleLabel?.font = .boldSystemFont(ofSize: Constants.labelTitleLogoutButtonFont)
        logoutButton.tintColor = .ypWhite
        logoutButton.addTarget(nil, action: #selector(didTapLogout), for: .touchUpInside)
        
        return logoutButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oAuth2Service = OAuth2Service()
        
        setupUIElement()
        applyConstraint()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @objc private func didTapLogout() {
        let webViewViewController = WebViewViewController()
        webViewViewController.modalPresentationStyle = .fullScreen
        let authHelper = AuthHelper()
        let webViewPresenter = WebViewPresenter(authHelper: authHelper)
        webViewViewController.presenter = webViewPresenter
        webViewPresenter.view = webViewViewController
        webViewViewController.delegate = self
        self.present(webViewViewController, animated: true)
    }
}

//MARK: - Delegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        guard let delegate = delegate else { return }
        delegate.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}

//MARK: - Setup UIElement
private extension AuthViewController {
    func setupUIElement() {
        view.backgroundColor = .ypBlack
        [imageView, logoutButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func applyConstraint() {
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
