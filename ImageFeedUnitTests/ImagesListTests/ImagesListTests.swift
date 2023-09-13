//
//  ImagesListTests.swift
//  ImagesListTests
//
//  Created by Григорий Машук on 8.08.23.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    let imagesListViewController = ImagesListViewController()
    let presenterSpy = ImagesListPresenterSpy()
    let imagesListViewControllerSpy = ImagesListViewControllerSpy()
    let imagesListService = ImagesListService()
    let imagesListHelper = ImagesListHelper()
    let imagesListTestServiceStub = ImagesListServiceStub()
    
    func testViewControllerCallsViewDidLoad() {
        //given
        imagesListViewController.presenter = presenterSpy
        presenterSpy.view = imagesListViewController
        
        //when
        _ = imagesListViewController.view
        
        //then
        XCTAssertTrue(presenterSpy.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateTableViewAnimated() {
        let presenter = ImagesListViewControllerPresenter(imagesListService: imagesListService,
                                                          imagesListHelper: imagesListHelper)
        //given
        
        presenter.view = imagesListViewControllerSpy
        
        //When
        presenter.viewDidLoad()
        
        //then
        XCTAssertTrue(imagesListViewControllerSpy.updateTableViewAnimatedCalled)
    }
    
    func testPresenterFetchPhotosNextPage() {
        //given
        let presenter = ImagesListViewControllerPresenter(imagesListService: imagesListTestServiceStub,
                                                          imagesListHelper: imagesListHelper)
        imagesListViewControllerSpy.presenter = presenter
        presenter.view = imagesListViewControllerSpy
        
        //when
        presenter.viewDidLoad()
        
        //then
        XCTAssertEqual(imagesListTestServiceStub.photos.count, 2)
    }
    
    func testPresenterCallsSetupListIndexPath() {
        //given
        imagesListViewController.presenter = presenterSpy
        presenterSpy.view = imagesListViewController
        
        //when
        let tableView = UITableView()
        presenterSpy.setupListIndexPath(tableView: tableView) { _ in }
        
        //then
        XCTAssertTrue(presenterSpy.setupListIndexPathCalled)
    }
    
    func testPresenterCallsSetupCell() {
        //given
        imagesListViewController.presenter = presenterSpy
        presenterSpy.view = imagesListViewController
        
        //when
        let tableView = UITableView()
        let indexPath = IndexPath(row: 1, section: 1)
        _ = presenterSpy.setupCell(tableView: tableView, indexPath: indexPath)
        
        //then
        XCTAssertTrue(presenterSpy.setupCellCalled)
    }
    
    func testImagesListHelperDidModel() {
        //given
        
        //when
        let photoModel = imagesListTestServiceStub.photo
        let testModel = imagesListHelper.didModel(photo: photoModel)
        
        //then
        XCTAssertEqual(testModel.textLabel, "")
    }
    
    func testPresenterSetupThumbImageURL() {
        //given
        let presenter = ImagesListViewControllerPresenter(imagesListService: imagesListTestServiceStub,
                                                          imagesListHelper: imagesListHelper)
        //when
        let indexPath = IndexPath(row: 0, section: 0)
        
        //then
        XCTAssertEqual(try presenter.setupThumbImageURL(indexPath: indexPath, photos: presenter.imagesListService!.photos)?.absoluteString, "https://api.unsplash.com")
    }
    
    func testPresenterSetupLargeURLImage() {
        //given
        let presenter = ImagesListViewControllerPresenter(imagesListService: imagesListTestServiceStub,
                                                          imagesListHelper: imagesListHelper)
        //when
        let indexPath = IndexPath(row: 0, section: 0)
        
        //then
        XCTAssertThrowsError(try presenter.setupLargeURLImage(indexPath: indexPath, photos: presenter.imagesListService!.photos)) { error in
            XCTAssertEqual(error as? ImageFeed.NetworkError, .urlError)
        }
    }
}
