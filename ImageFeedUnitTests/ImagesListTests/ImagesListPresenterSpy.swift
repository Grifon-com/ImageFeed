//
//  ImagesListPresenterSpy.swift
//  ImagesListTests
//
//  Created by Григорий Машук on 8.08.23.
//

import ImageFeed
import UIKit


final class ImagesListPresenterSpy: ImagesListPresenterProtocol {
    var photos: [Photo] = []
    var view: ImageFeed.ImagesListViewControllerProtocol?
    var imagesListService: ImageFeed.ImagesListServiceProtocol?
    var imagesListConfiguration: ImageFeed.ImagesListConfiguration?
    
    var viewDidLoadCalled: Bool = false
    var setupListIndexPathCalled: Bool = false
    var setupCellCalled: Bool = false
    var setupThumbImageURLCalled: Bool = false
    
    func viewDidload() {
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
    func setupThumbImageURL(indexPath: IndexPath) throws -> URL? {
        setupThumbImageURLCalled = true
        return nil }
    func setupLargeURLImage(indexPath: IndexPath) throws -> URL? { nil }
    func fetchPhotosNextPage() {}  //test
    func cellHeightCalculation(imageSize: CGSize, tableView: UITableView) -> CGFloat { CGFloat(0) }
}
