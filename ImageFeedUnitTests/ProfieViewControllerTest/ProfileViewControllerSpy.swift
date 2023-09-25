//
//  ProfilesViewControllerSpy.swift
//  TestProfieViewController
//
//  Created by Григорий Машук on 10.08.23.
//

@testable import ImageFeed
import Foundation

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var presenter: ImageFeed.ProfileViewControllerPresenterProtocol?
    var updateProfileDetailsCalled = false
    func updateProfileDetails(profile: ImageFeed.Profile?) {
        updateProfileDetailsCalled = true
    }
    func updateAvatar() {}
}
