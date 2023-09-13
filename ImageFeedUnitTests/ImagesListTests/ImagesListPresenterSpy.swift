//
//  ImagesListPresenterSpy.swift
//  ImagesListTests
//
//  Created by Григорий Машук on 8.08.23.
//

import ImageFeed
import UIKit


final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var photos: [Photo] = [Photo(id: "test",
                                 size: CGSize(width: 5, height: 5),
                                 createdAt: nil,
                                 welcomeDescription: nil,
                                 thumbImageURL: "https://api.unsplash.com",
                                 largeImageURL: "test",
                                 isLiked: true)]
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var imagesListService: ImageFeed.ImagesListServiceProtocol?
    var imagesListConfiguration: ImageFeed.ImagesListConfiguration?
    
    var viewDidLoadCalled: Bool = false
    var setupListIndexPathCalled: Bool = false
    var setupCellCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
        fetchPhotosNextPage()
    }
    func imageListCellDidTapLike(cell: ImageFeed.ImagesListCell, tableView: UITableView, completion: @escaping (Result<Void, Error>) -> ()) {}
    func setupListIndexPath(tableView: UITableView, completion: @escaping ([IndexPath]) -> (Void)) {
        setupListIndexPathCalled = true
    }
    func setupCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        setupCellCalled = true
        return UITableViewCell() }
    func setupThumbImageURL(indexPath: IndexPath, photos: [Photo]) throws -> URL? { return URL(string: "www") }
    func setupLargeURLImage(indexPath: IndexPath, photos: [Photo]) throws -> URL? { return URL(string: "www") }
    func fetchPhotosNextPage() {}  //test
    func cellHeightCalculation(imageSize: CGSize, tableView: UITableView) -> CGFloat { CGFloat(0) }
}
