//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 27.06.23.
//

import UIKit

final class SplashViewController: UIViewController {
    private let ShowAuthenticationScreenSegueIdentifier = "ShowAuthenticationScreen"
    
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    private var splashImageView: UIImageView = {
        let splashImage = UIImage(named: "Vector")
        let splashImageView = UIImageView(image: splashImage)
        splashImageView.backgroundColor = .clear
        splashImageView.translatesAutoresizingMaskIntoConstraints = false
        
        return splashImageView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = oauth2TokenStorage.token {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: ShowAuthenticationScreenSegueIdentifier, sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(splashImageView)
        view.backgroundColor = .ypBlack
        
        applyConstraints()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            splashImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            splashImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
        ])
    }
}

//MARK: Setting a delegate
extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Проверим, что переходим на авторизацию
        if segue.identifier == ShowAuthenticationScreenSegueIdentifier {
            //Находим первый контроллер в навигации
            guard let navigationController = segue.destination as? UINavigationController,
                  let viewController = navigationController.viewControllers[1] as? AuthViewController
            else {fatalError("Failed to prepare for \(ShowAuthenticationScreenSegueIdentifier)")}
            
            //Установим делегатом AuthViewController наш SplashViewController
            viewController.delegate = self
        } else {super.prepare(for: segue, sender: sender)}
    }
}


extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String) {
        self.oauth2Service.fetchAuthToken(code) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.switchToTabBarController()
            case .failure:
                break
            }
        }
    }
}

//MARK: SwitchToTabBarController
extension SplashViewController {
    private func switchToTabBarController() {
        //Получаем экземпляр Window приложения
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        
        //Создаём экземпляр нужного контроллера из Storyboard с помошью ранее заданного идентификатора
        let tabBarController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(identifier: "TabBarViewController")
        
        //Установим в rootVeiwController полученный контроллер
        window.rootViewController = tabBarController
    }
}
