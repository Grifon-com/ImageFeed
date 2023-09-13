//
//  ProfileViewControllerPresenterSpy.swift
//  TestProfieViewController
//
//  Created by Григорий Машук on 10.08.23.
//

import ImageFeed
import Foundation

final class ProfileViewControllerPresenterSpy: ProfileViewControllerPresenterProtocol {
    var configuration: ImageFeed.ProfileConfiguration
    var viewDidLoadCalled: Bool = false
    var cleanCookiAndTokenCalled: Bool = false
    let jsonDefaultBaseURL = "https://api.unsplash.com"
    var view: ProfileViewControllerProtocol?
    var profileImageServiceObserver: NSObjectProtocol?
    var profileService: ImageFeed.ProfileServiceProtocol?
    
    init(configuration: ImageFeed.ProfileConfiguration) {
        self.configuration = configuration
    }
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func cleanCookiAndToken() {
        cleanCookiAndTokenCalled = true
    }
    
    func greatAvatareURL(urlString: String) throws -> URL {
        return URL(string: jsonDefaultBaseURL)!
    }
}
