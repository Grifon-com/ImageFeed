//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 27.05.23.
//

import UIKit
import Kingfisher

public protocol ProfileViewControllerProtocol: AnyObject {
    var presenter: ProfileViewControllerPresenterProtocol? { get set }
    func updateAvatar()
    func updateProfileDetails(profile: Profile?)
}

final class ProfileViewController: UIViewController & ProfileViewControllerProtocol {
    var presenter: ProfileViewControllerPresenterProtocol?
        
    private lazy var avatarImageView: UIImageView = {
        guard let presenter else { return UIImageView() }
        let avatarImage = UIImage(named: presenter.configuration.imageAvatar)
        let avatarImageView = UIImageView(image: avatarImage)
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        
        return avatarImageView
    }()
    
    private lazy var nameLabel: UILabel = {
        guard let presenter else { return UILabel() }
        let nameLabel = UILabel()
        nameLabel.text = presenter.configuration.labelText
        nameLabel.textColor = .ypWhite
        nameLabel.font = .boldSystemFont(ofSize: presenter.configuration.labelFont)
        
        return nameLabel
    }()
    
    private lazy var loginNameLabel: UILabel = {
        guard let presenter else { return UILabel() }
        let loginNameLabel = UILabel()
        loginNameLabel.text = presenter.configuration.loginLabelText
        loginNameLabel.textColor = .ypGrey
        loginNameLabel.font = UIFont.systemFont(ofSize: presenter.configuration.labelLoginFont)
        
        return loginNameLabel
    }()
    
    private lazy var descriptionLabel: UILabel = {
        guard let presenter else { return UILabel() }
        let descriptionLabel = UILabel()
        descriptionLabel.text = presenter.configuration.descriptionLabelText
        descriptionLabel.textColor = .ypWhite
        descriptionLabel.font = UIFont.systemFont(ofSize: presenter.configuration.labelDescriptionFont)
        
        return descriptionLabel
    }()
    
    private lazy var logoutButton: UIButton = {
        guard let presenter else { return UIButton() }
        let logoutButton = UIButton()
        let imageButton = UIImage(named: presenter.configuration.imageLogoutButton)
        logoutButton.setImage(imageButton, for: .normal)
        logoutButton.addTarget(nil, action: #selector(didTapLogoutButton), for: .allTouchEvents)
        logoutButton.tintColor = .ypRed
        
        return logoutButton
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIElement()
        applyConstraints()
        presenter?.viewDidLoad()
    }
    
    @objc
    private func didTapLogoutButton() {
        guard let presenter else { return }
        let alert = UIAlertController(title: presenter.configuration.alertTitle,
                                      message: presenter.configuration.alertMessage,
                                      preferredStyle: .alert)
        
        let actionAlertOne = UIAlertAction(title: presenter.configuration.titleActionOne,
                                           style: .default) { _ in
            guard let window = UIApplication.shared.windows.first else { return }
            presenter.cleanCookiAndToken()
            
            let splashViewController = SplashViewController()
            window.rootViewController = splashViewController
        }
        let alertActionTwo = UIAlertAction(title: presenter.configuration.titleActionTwo, style: .default) { _ in
            alert.dismiss(animated: true)
        }
        alert.addAction(actionAlertOne)
        alert.addAction(alertActionTwo)
        self.present(alert, animated: true)
    }
}

extension ProfileViewController {
    //MARK: Update profile image for kingfisher
    func updateAvatar() {
        guard let presenter,
        let avatarURL = ProfileImageService.shared.avatarURL
        else { return }
        do {
            let url = try presenter.greatAvatareURL(urlString: avatarURL)
            let placeholder = UIImage(named: presenter.configuration.imagePlaceholder)
            avatarImageView.kf.setImage(with: url, placeholder: placeholder)
        }
        catch { let urlError = NetworkError.urlError
            print(urlError)
        }
    }
}

extension ProfileViewController {
    //MARK: UpdateProfileDetails
    func updateProfileDetails(profile: Profile?) {
        guard let profile = profile else { return }
        nameLabel.text = profile.name
        loginNameLabel.text = profile.loginName
        descriptionLabel.text = profile.bio
    }
    
    //MARK: SetupUIElement
    func setupUIElement() {
        view.backgroundColor = .ypBlack
        [avatarImageView, nameLabel, loginNameLabel, descriptionLabel, logoutButton].forEach {
            view.addSubview($0)
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nameLabel.topAnchor.constraint(equalTo:avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
}


