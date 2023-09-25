//
//  ImagesListViewControllerPresenter.swift
//  ImageFeed
//
//  Created by Григорий Машук on 5.08.23.
//

import UIKit

protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set }
    var imagesListService: ImagesListServiceProtocol? { get set }
    var imagesListConfiguration: ImagesListConfiguration? { get }
    func viewDidLoad()
    func fetchPhotosNextPage()
    func setupListIndexPath(tableView: UITableView, completion: @escaping ([IndexPath]) -> (Void))
    func cellHeightCalculation(imageSize: CGSize, tableView: UITableView) -> CGFloat
    func imageListCellDidTapLike(cell: ImagesListCell, tableView: UITableView, completion: @escaping (Result<Void, Error>) -> ())
    func setupCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell
    func setupThumbImageURL(indexPath: IndexPath, photos: [Photo]) throws -> URL?
    func setupLargeURLImage(indexPath: IndexPath, photos: [Photo]) throws -> URL?
}

final class ImagesListViewControllerPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var imagesListService: ImagesListServiceProtocol?
    var imagesListConfiguration: ImagesListConfiguration?
    var imageListServiceObserver: NSObjectProtocol?
    var imagesListHelper: ImagesListHelperProtocol
    
    init(imagesListService: ImagesListServiceProtocol?,
         imagesListConfiguration: ImagesListConfiguration = .standart,
         imagesListHelper: ImagesListHelperProtocol) {
        self.imagesListService = imagesListService
        self.imagesListConfiguration = imagesListConfiguration
        self.imagesListHelper = imagesListHelper
    }
    
    func viewDidLoad() {
        guard let view else { return }
        fetchPhotosNextPage()
        imageListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main) {  [weak self]_ in
            guard let self, let view = self.view else { return }
            UIBlockingProgressHUD.dismiss()
            view.updateTableViewAnimated()
        }
        view.updateTableViewAnimated()
    }
    
    func setupImagesListCellModel(indexPath: IndexPath) -> ImagesListCellModel {
        let photo = photos[indexPath.row]
        let model = imagesListHelper.didModel(photo: photo)
        
        return model
    }
    
    func setupListIndexPath(tableView: UITableView, completion: @escaping ([IndexPath]) -> (Void)) {
        guard  let imagesListService else { return }
        tableView.performBatchUpdates {
            let endIndex = imagesListService.photos.count
            let startIndex = photos.count
            photos = imagesListService.photos
            if startIndex != endIndex {
                let listIndexPath = (startIndex..<endIndex).map {
                    IndexPath(row: $0, section: 0)
                }
                completion(listIndexPath)
            }
        }
    }
    
    func fetchPhotosNextPage() {
        guard let imagesListService else { return }
        imagesListService.fetchPhotosNextPage()
    }
    
    func cellHeightCalculation(imageSize: CGSize, tableView: UITableView) -> CGFloat {
        guard let indents = imagesListConfiguration?.cellViewIndents else { return CGFloat(Null) }
        let heightImageView = imagesListHelper.cellHeightCalculation(imageSize: imageSize, indents: indents, tableView: tableView)
        return heightImageView
    }
    
    public func imageListCellDidTapLike(cell: ImagesListCell, tableView: UITableView, completion: @escaping (Result<Void, Error>) -> ()) {
        guard let imagesListService else { return }
        let fulfillCompletion: (Result<Void, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        UIBlockingProgressHUD.show()
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        imagesListService.chengeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            fulfillCompletion(result)
        }
    }
    
    func setupCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.Constants.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else { return  UITableViewCell() }
        let model = setupImagesListCellModel(indexPath: indexPath)
        imageListCell.configure(model: model)
        return imageListCell
    }
    
    func setupThumbImageURL(indexPath: IndexPath, photos: [Photo]) throws -> URL? {
        let urlString = photos[indexPath.row].thumbImageURL
        guard let url = URL(string: urlString) else { throw NetworkError.urlError }
        return url
    }
    
    func setupLargeURLImage(indexPath: IndexPath, photos: [Photo]) throws -> URL? {
        let urlString = photos[indexPath.row].largeImageURL
        guard let url = URL(string: urlString) else { throw NetworkError.urlError }
        return url
    }
}
