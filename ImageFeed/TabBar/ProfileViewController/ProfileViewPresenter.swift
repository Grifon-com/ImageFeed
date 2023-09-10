//
//  ProfileViewPresenter.swift
//  ImageFeed
//
//  Created by Григорий Машук on 4.08.23.
//

import UIKit

public protocol ProfileViewControllerPresenterProtocol {
    var view: ProfileViewControllerProtocol? { get set }
    func viewDidLoad()
    var profileService: ProfileServiceProtocol? { get set }
    var configuration: ProfileConfiguration { get set } 
    func cleanCookiAndToken()
    func greatAvatareURL(urlString: String) throws -> URL
}

final class ProfileViewControllerPresenter: ProfileViewControllerPresenterProtocol {
    weak var view: ProfileViewControllerProtocol?
    var profileImageServiceObserver: NSObjectProtocol?
    var profileService: ProfileServiceProtocol?
    var cleanmanager: CleanManagerProtocol?
    var configuration: ProfileConfiguration
   
    init(cleanmanager: CleanManagerProtocol, profileService: ProfileServiceProtocol, configuration: ProfileConfiguration = ProfileConfiguration.standart) {
        self.cleanmanager = cleanmanager
        self.profileService = profileService
        self.configuration = configuration
    }
    
    func viewDidLoad() {
        updateProfileDetails(profile: profileService?.profile)
        profileImageServiceObserver = NotificationCenter.default.addObserver(forName: ProfileImageService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self else { return }
            view?.updateAvatar()
        }
        view?.updateAvatar()
    }
    
    func cleanCookiAndToken() {
        guard let cleanmanager else { return }
        cleanmanager.cleanCookies()
        cleanmanager.cleanToken()
    }
    
    func greatAvatareURL(urlString: String) throws -> URL {
        guard let url = URL(string: urlString) else { throw NetworkError.urlError }
        return url
    }
    
    func updateProfileDetails(profile: Profile?) {
        view?.updateProfileDetails(profile: profile)
    }
}
