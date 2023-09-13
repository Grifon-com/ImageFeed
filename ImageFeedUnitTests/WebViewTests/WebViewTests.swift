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
    func testViewControllerCallsViewDidLoad() {
        //given
        let presenter = WebViewPresenterSpy()
        let viewController = WebViewViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        //given
        let helper = AuthHelper()
        let viewController = WebViewViewControllerSpy()
        let presenter = WebViewPresenter(authHelper: helper)
        presenter.view = viewController
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(viewController.loadRequestCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 0.6
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        //given
        let authHelper = AuthHelper()
        let presenter = WebViewPresenter(authHelper: authHelper)
        let progress: Float = 1
        
        //when
        let shouldHideProgress = presenter.shouldHideProgress(for: progress)
        
        //then
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        //given
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        
        //when
        let url = authHelper.authURL()
        let urlString = url.absoluteString
        
        //then
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains(ConstantsImageFeed.code))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        //given
        let configuration = AuthConfiguration.standard
        let helper = AuthHelper(configuration: configuration)
        let urlComponentsString = "\(configuration.defaultBaseURL)\(ConstantsImageFeed.authNativePath)"
        var urlComponents = URLComponents(string: urlComponentsString)!
        urlComponents.queryItems = [URLQueryItem(name: ConstantsImageFeed.code, value: TestCodeString)]
        let url = urlComponents.url!
        
        //when
        let code = helper.code(from: url)
        
        //then
        XCTAssertEqual(code, TestCodeString)
    }
}
