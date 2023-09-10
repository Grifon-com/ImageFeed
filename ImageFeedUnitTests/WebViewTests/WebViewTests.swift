//
//  WebViewTests.swift
//  ImageFeedTests
//
//  Created by Григорий Машук on 25.05.23.
//

@testable import ImageFeed
import XCTest

let TestCodeString = "test code"

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidload() {
        //Given
        let presenter = WebViewPresenterSpy()
        let viewController = WebViewViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //When
        _ = viewController.view
        
        //Then
        XCTAssertTrue(presenter.viewDidLoadeCalled) //behaviour verification
    }
    
    func testPresenterCallsLoadRequest() {
        //Given
        let helper = AuthHelper()
        let viewController = WebViewViewControllerSpy()
        let presenter = WebViewPresenter(authHelper: helper)
        presenter.view = viewController
        
        //When
        presenter.viewDidload()
        
        //Then
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        //Given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        //When
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //Then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        //Given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1
        
        //When
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //Then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        //Given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        //When
        let url = authHelper.authURL()
        let urlString = url.absoluteString
        
        //Then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains(ConstantsImageFeed.code))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        //Given
        let configuration = AuthConfiguration.standard
        let helper = AuthHelper(configuration: configuration)
        let urlComponentsString = "\(configuration.defaultBaseURL)\(ConstantsImageFeed.authNativePath)"
        var urlComponents = URLComponents(string: urlComponentsString)!
        urlComponents.queryItems = [URLQueryItem(name: ConstantsImageFeed.code, value: TestCodeString)]
        let url = urlComponents.url!
        
        //When
        let code = helper.code(from: url)
        
        //Then
        XCTAssertEqual(code, TestCodeString)
    }
}
