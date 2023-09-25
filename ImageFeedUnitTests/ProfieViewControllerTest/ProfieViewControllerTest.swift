//
//  ProfieViewControllerTest.swift
//  ProfieViewControllerTest
//
//  Created by Григорий Машук on 5.08.23.
//

@testable import ImageFeed
import XCTest

final class ProfieViewControllerTest: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        let vc = ProfileViewController()
        let presenter = ProfileViewControllerPresenterSpy(configuration: ProfileConfiguration.standart)
        vc.presenter = presenter
        presenter.view = vc
        
        //when
        _ = vc.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterSetupURL() {
        //given
        let vc = ProfileViewControllerSpy()
        let cleanManager = CleanManager(tokenStorage: OAuth2TokenKeychainStorage())
        let profileService = ProfileService()
        let presenter = ProfileViewControllerPresenter(cleanmanager: cleanManager, profileService: profileService)
        vc.presenter = presenter
        presenter.view = vc
        
        //when
        var url: URL
        do { let urlResult = try presenter.greatAvatareURL(urlString: ImageFeed.ConstantsImageFeed.jsonDefaultBaseURL)
            url = urlResult
            
            //then
            let urlString = url.absoluteString
            XCTAssertTrue(urlString.contains("https"))
            XCTAssertTrue(urlString.contains("api"))
            XCTAssertTrue(urlString.contains("unsplash"))
            XCTAssertTrue(urlString.contains("com"))
        }
        catch { print(error) }
    }
    
    func testPresenterCleanCookiAndToken() {
        //given
        let vc = ProfileViewControllerSpy()
        let presenter = ProfileViewControllerPresenterSpy(configuration: ProfileConfiguration.standart)
        vc.presenter = presenter
        presenter.view = vc
        
        //when
        vc.presenter?.cleanCookiAndToken()
        
        //then
        XCTAssertTrue(presenter.cleanCookiAndTokenCalled)
    }
    
    func testViewVcUpdateProfileDetails() {
        //given
        let vc = ProfileViewControllerSpy()
        let cleanManager = CleanManager(tokenStorage: OAuth2TokenKeychainStorage())
        let profileService = ProfileService()
        let presenter = ProfileViewControllerPresenter(cleanmanager: cleanManager, profileService: profileService)
        vc.presenter = presenter
        presenter.view = vc
        
        //when
        let profile = Profile(username: "test", name: "test", loginName: "test", bio: "test")
        presenter.updateProfileDetails(profile: profile)
        
        //then
        XCTAssertTrue(vc.updateProfileDetailsCalled)
    }
}
