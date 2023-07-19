//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 29.06.23.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private var oAuth2Service: OAuth2ServiceProtocol?
    private var OAuth2TokenKeychainStorage: OAuth2TokenKeychainStorage?
    private let profileService = ProfileService.shared
    
    private var imageView: UIImageView = {
        let image = UIImage(named: "Vector")
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oAuth2Service = OAuth2Service()
        OAuth2TokenKeychainStorage = ImageFeed.OAuth2TokenKeychainStorage()
        
        view.addSubview(imageView)
        view.backgroundColor = .ypBlack
        
        applyConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = OAuth2TokenKeychainStorage?.getToken() {
            fetchProfile(token: token)
        } else {
            let authViewController = AuthViewController()
            authViewController.delegate = self
            authViewController.modalPresentationStyle = .fullScreen
            present(authViewController, animated: true)
        }
    }
}

//MARK: - Delegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
}

//MARK: - Service
extension SplashViewController {
    private func fetchOAuthToken(_ code: String) {
        guard let oAuth2Service = oAuth2Service else { return }
        oAuth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let token):
                self.fetchProfile(token: token)
            case .failure:
                UIBlockingProgressHUD.dismiss()
                showAlert(vc: self)
            }
        }
    }
    
    private func fetchProfile(token: String) {
        profileService.fetchProfile(token) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                guard let username = self.profileService.profile?.username else { return }
                ProfileImageService.shared.fetchProfileImageUrl(username: username) {_ in }
                UIBlockingProgressHUD.dismiss()
                self.switchToTabBarController()
            case .failure:
                UIBlockingProgressHUD.dismiss()
                showAlert(vc: self)
            }
        }
    }
}

//MARK: - switchToTabBarController
private extension SplashViewController {
    private func switchToTabBarController() {
        //Получаем экземпляр Window приложения
        guard let window = UIApplication.shared.windows.first else { return }
        
        let tabBarController = TabBarViewController()
        
        //Установим в rootViewController полученный контроллер
        window.rootViewController = tabBarController
    }
}

//MARK: - AlertPresent
private extension SplashViewController {
    private func showAlert(vc: UIViewController) {
        let title = "Что-то пошло не так("
        let message = "Не удалось войти в систему"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(action)
        vc.present(alert, animated: true)
    }
}

//MARK: - SetupUIElement
extension SplashViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

