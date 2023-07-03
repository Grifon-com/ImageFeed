//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 29.06.23.
//

import UIKit

final class SplashViewController: UIViewController {
    private let showAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private var oAuth2Service: OAuth2ServiceProtocol?
    private var oauth2TokenStorage: StorageTokenProtocol?
    
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
        oauth2TokenStorage = OAuth2TokenStorage()
        
        view.addSubview(imageView)
        view.backgroundColor = .ypBlack
        applyConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let _ = oauth2TokenStorage?.token {
            switchToTabBarController()
        } else { performSegue(withIdentifier: showAuthenticationScreenSegueIdentifier, sender: nil) }
    }
    
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

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        guard let oAuth2Service = oAuth2Service else { return }
        oAuth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure(_):
                break
            }
        }
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Проверим, что переходим на авторизацию
        if segue.identifier == showAuthenticationScreenSegueIdentifier {
            //Находим первый контроллер
            guard let navigationController = segue.destination as? UINavigationController,
                  let viewController = navigationController.viewControllers.first as? AuthViewController else { return }
            viewController.delegate = self
        } else { super.prepare(for: segue, sender: sender) }
    }
}

extension SplashViewController {
    private func switchToTabBarController() {
        //Получаем экземпляр Window приложения
        guard let window = UIApplication.shared.windows.first else { return }
        
        //Создаём экземпляр нужного контроллера из Storyboard с помощью заданного идентификатора
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "TabBarViewController")
        
        //Установим в rootViewController полученный контроллер
        window.rootViewController = tabBarController
    }
}
