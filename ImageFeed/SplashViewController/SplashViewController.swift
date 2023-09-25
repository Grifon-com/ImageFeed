//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 29.06.23.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private struct Constants {
        static let imageSplash = "Vector"
    }
    
    private var oAuth2Service = OAuth2Service.shared
    private var OAuth2TokenKeychainStorage: OAuth2TokenKeychainStorage?
    private let profileService = ProfileService.shared
    
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: Constants.imageSplash)
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OAuth2TokenKeychainStorage = ImageFeed.OAuth2TokenKeychainStorage()
        
        setupUIElement()
        applyConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let token = OAuth2TokenKeychainStorage?.getToken() {
            UIBlockingProgressHUD.show()
            fetchProfile(token: token)
        } else {
            let authViewController = AuthViewController()
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
        }
    }
}

private extension SplashViewController {
    //MARK: Service
    func fetchOAuthToken(_ code: String) {
        oAuth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                self.showAlert()
            }
        }
    }
    
    func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                guard let username = self.profileService.profile?.username else { return }
                ProfileImageService.shared.fetchProfileImageUrl(username: username) {_ in }
                self.switchToTabBarController()
            case .failure(let error):
                self.showAlert()
                print(error)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    //MARK: switchToTabBarController
    func switchToTabBarController() {
        //Получаем экземпляр Window приложения
        guard let window = UIApplication.shared.windows.first else { return }
        
        let tabBarController = TabBarViewController()
        
        //Установим в rootViewController полученный контроллер
        window.rootViewController = tabBarController
    }
    
    //MARK: AlertPresent
    func showAlert() {
        let title = ConstantsImageFeed.alertTitle
        let message = ConstantsImageFeed.alertMessage
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: ConstantsImageFeed.alertActionTitle, style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    //MARK: Delegate
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            fetchOAuthToken(code)
        }
    }
    
    //MARK: SetupUIElement
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func setupUIElement() {
        view.addSubview(imageView)
        view.backgroundColor = .ypBlack
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
}

