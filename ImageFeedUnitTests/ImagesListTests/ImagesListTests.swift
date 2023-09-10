//
//  ImagesListTests.swift
//  ImagesListTests
//
//  Created by Григорий Машук on 8.08.23.
//

@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //Given
        let imagesListViewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        imagesListViewController.presenter = presenter
        presenter.view = imagesListViewController
        
        //When
        _ = imagesListViewController.view
        
        //Then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsUpdateTableViewAnimated() {
        //Given
        let imagesListViewControllerSpy = ImagesListViewControllerSpy()
        let imagesListService = ImagesListService()
        let imagesListHelper = ImagesListHelper()
        let present = ImagesListViewControllerPresenter(imagesListService: imagesListService,
                                                        imagesListHelper: imagesListHelper)
        present.view = imagesListViewControllerSpy
        
        //When
        present.viewDidload()
        
        //then
        XCTAssertTrue(imagesListViewControllerSpy.updateTableViewAnimatedCalled)
    }
    
    func testPresenterFetchPhotosNextPage() {
        //Given
        let imagesListViewController = ImagesListViewControllerSpy()
        let imagesListTestServiceStub = ImagesListServiceStub()
        let imagesListHelper = ImagesListHelper()
        let presenter = ImagesListViewControllerPresenter(imagesListService: imagesListTestServiceStub,
                                                          imagesListHelper: imagesListHelper)
        imagesListViewController.presenter = presenter
        presenter.view = imagesListViewController
        
        //when
        presenter.viewDidload()
        
        //then
        XCTAssertEqual(imagesListTestServiceStub.photos.count, 1)
    }
    
    func testPresenterCallsSetupListIndexPath() {
        //given
        let imagesListViewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        imagesListViewController.presenter = presenter
        presenter.view = imagesListViewController
        
        //when
        let tableView = UITableView()
        presenter.setupListIndexPath(tableView: tableView) { _ in }
        
        //then
        XCTAssertTrue(presenter.setupListIndexPathCalled)
    }
    
    func testPresenterCallsSetupCell() {
        //given
        let imagesListViewController = ImagesListViewController()
        let presenter = ImagesListPresenterSpy()
        imagesListViewController.presenter = presenter
        presenter.view = imagesListViewController
        
        //when
        let tableView = UITableView()
        let indexPath = IndexPath(row: 1, section: 1)
        _ = presenter.setupCell(tableView: tableView, indexPath: indexPath)
        
        //then
        XCTAssertTrue(presenter.setupCellCalled)
    }
    
    func testImagesListHelperDidModel() {
        //given
        let imagesListHelper = ImagesListHelper()
        
        //when
        let photoModel = Photo(id: "test",
                               size: CGSize(width: 50, height: 50),
                               createdAt: nil,
                               welcomeDescription: nil,
                               thumbImageURL: "https://api.unsplash.com",
                               largeImageURL: "https://api.unsplash.com",
                               isLiked: true)
        let testModel = imagesListHelper.didModel(photo: photoModel)
        
        //then
        XCTAssertEqual(testModel.textLabel, "")
    }
}
