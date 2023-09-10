//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Григорий Машук on 23.07.23.
//

import Foundation

public protocol ImagesListServiceProtocol {
    var photos: [Photo] { get set }
    func fetchPhotosNextPage()
    func chengeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void)
}

final class ImagesListService: ImagesListServiceProtocol {
    private struct Constants {
        static let sizeDefault = (heigt: 0, width: 0)
        static let userInfoKey = "listPhoto"
        static let pageString = "page"
        static let likeString = "/like"
        static let path = "/photos/"
        static let notificationName = "ImageListServiceDidChange"
    }
    static let didChangeNotification = Notification.Name(Constants.notificationName)
    
    static let shared = ImagesListService()
    
    var photos: [Photo] = []
    private (set) var lastLoadedPage: Int?
    
    private let urlSession = URLSession.shared
    private let dateFormatter = FormatDate.shared
    private var component = URLComponents(string: ConstantsImageFeed.jsonDefaultBaseURL)
    private var photosNextPageTask: URLSessionTask?
    private var putLikeTask: URLSessionTask?
    private var deleteTask: URLSessionTask?
    private var token: String?
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard photosNextPageTask == nil else { return }
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        lastLoadedPage = nextPage
        var request: URLRequest?
        do { let modelRequest = try imageListServiceRequestForPage(page: nextPage)
            request = modelRequest
        }
        catch {
            let errorRequest = NetworkError.urlComponentsError
            print(errorRequest)
        }
        guard let request = request else { return }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result <[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let listModel):
                listModel.forEach {
                    let photoModel = self.convertModel(model: $0)
                        self.photos.append(photoModel)
                }
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self, userInfo: [Constants.userInfoKey: self.photos])
                self.photosNextPageTask = nil
            case .failure(let error):
                print(error)
            }
        }
        self.photosNextPageTask = task
        task.resume()
    }
    
    //MARK: Chenge Like
    func chengeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {
        isLike ? self.putLike(photoId: photoId) { [weak self] (result: Result <Like, Error>)  in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.convertIsLike(photoId: photoId)
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        } : self.deleteLike(photoId: photoId) { [weak self] (result: Result <Void, Error>)  in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.convertIsLike(photoId: photoId)
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

private extension ImagesListService {
    //MARK: Delete Put Like
    func deleteLike(photoId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard deleteTask == nil else { return }
        var request: URLRequest?
        do { let requestForLike = try imageListServiceRequestForLike(photoId: photoId, isLike: ConstantsImageFeed.isFalse)
            request = requestForLike
        }
        catch {
            let errorRequest = NetworkError.urlComponentsError
            completion(.failure(errorRequest))
        }
        guard let request = request else { return }
        let task = urlSession.statusCode(for: request) { [weak self] (result: Result <Void, Error>) in
            guard let self = self else { return }
            switch result {
            case .success():
                completion(.success(Void()))
                self.deleteTask = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.deleteTask = task
        task.resume()
    }
    
    func putLike(photoId: String, completion: @escaping (Result<Like, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard putLikeTask == nil else { return }
        var request: URLRequest?
        do {
            let putLikeRequest = try imageListServiceRequestForLike(photoId: photoId, isLike: ConstantsImageFeed.isTrue)
            request = putLikeRequest
        }
        catch {
            let errorRequest = NetworkError.urlComponentsError
            completion(.failure(errorRequest))
        }
        guard let request = request else { return }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result <Like, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let like):
                completion(.success(like))
                self.putLikeTask = nil
            case .failure(let error):
                completion(.failure(error))
            }
        }
        self.putLikeTask = task
        task.resume()
    }
    
    //TODO: Image List Service For Page Request
    func imageListServiceRequestForPage(page: Int) throws -> URLRequest {
        guard var component = component else { throw NetworkError.urlComponentsError}
        component.queryItems = [URLQueryItem(name: Constants.pageString, value: "\(page)")]
        component.path = Constants.path
        guard let url = component.url else { throw NetworkError.urlComponentsError}
        
        guard let token = OAuth2TokenKeychainStorage().getToken() else { throw KeychainError.errorStorageToken}
        let bearerToken = "\(ConstantsImageFeed.bearer) \(token)"
        
        return URLRequest.makeHTTPRequestForModel(url: url, bearerToken: bearerToken, forHTTPHeaderField: ConstantsImageFeed.hTTPHeaderField)
    }
    
    //TODO: Image List Service For Like Request
    func imageListServiceRequestForLike(photoId: String, isLike: Bool) throws -> URLRequest {
        guard var component = component else { throw NetworkError.urlComponentsError }
        let path = "\(Constants.path)\(photoId)\(Constants.likeString)"
        component.path = path
        guard let url = component.url else { throw NetworkError.urlComponentsError }
        
        guard let token = OAuth2TokenKeychainStorage().getToken() else { throw KeychainError.errorStorageToken}
        let bearerToken = "\(ConstantsImageFeed.bearer) \(token)"
        
        return URLRequest.makeHTTPRequestForToken(url: url, bearerToken: bearerToken, forHTTPHeaderField: ConstantsImageFeed.hTTPHeaderField, httpMethod: isLike ? ConstantsImageFeed.postHTTPMethod : ConstantsImageFeed.deleteHTTPMethod)
        
    }
    
    func convertIsLike(photoId: String) {
        if let index = photos.firstIndex(where: { $0.id == photoId }) {
            // Текущий элемент
            let photo = photos[index]
            // Копия элемента с инвентированным значением isLiked.
            let newPhoto = Photo(id: photo.id,
                                 size: photo.size,
                                 createdAt: photo.createdAt,
                                 welcomeDescription: photo.welcomeDescription,
                                 thumbImageURL: photo.thumbImageURL,
                                 largeImageURL: photo.largeImageURL,
                                 isLiked: !photo.isLiked
            )
            // Заменяем значение в массиве
            photos[index] = newPhoto
        }
    }
    
    //MARK: Convert Model
    func convertModel(model: PhotoResult) -> Photo {
        let id = model.id ?? ConstantsImageFeed.emptyLine
        let heigt = model.height ?? Constants.sizeDefault.heigt
        let width = model.width ?? Constants.sizeDefault.width
        let size = CGSize(width: width, height: heigt)
        let welcomeDescription = model.description
        let thumbImageURL = model.urls?.thumb ?? ConstantsImageFeed.emptyLine
        let largeImageURL = model.urls?.regular ?? ConstantsImageFeed.emptyLine
        let isLiked = model.likedByUser ?? ConstantsImageFeed.isFalse
        let createAt = dateFormatter.setupModelDate(createAt: model.createdAt)
        
        let photoModel = Photo(id: id,
                               size: size,
                               createdAt: createAt,
                               welcomeDescription: welcomeDescription,
                               thumbImageURL: thumbImageURL,
                               largeImageURL: largeImageURL,
                               isLiked: isLiked)
        return photoModel
    }
}
