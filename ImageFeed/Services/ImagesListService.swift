//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Григорий Машук on 23.07.23.
//

import Foundation

protocol ImagesListServiceProtocol {
    func fetchPhotosNextPage()
}

final class ImagesListService: ImagesListServiceProtocol {
    private static let sizeDefault = (heigt: 0, width: 0)
    private static let userInfoKey = "listPhoto"
    private static let pageString = "page"
    private static let likeString = "/like"
    private static let path = "/photos/"
    static let didChangeNotification = Notification.Name("ImageListServiceDidChange")
    
    static let shared = ImagesListService()
    
    private (set) var photos: [Photo] = []
    private (set) var lastLoadedPage: Int?
    
    private let dateFormatter = DateFormat()
    private let urlSession = URLSession.shared
    private var component = URLComponents(string: ConstantsUnSplash.jsonDefaultBaseURL)
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
                    do { let photoModel = try self.convertModel(model: $0)
                        self.photos.append(photoModel)
                    }
                    catch {
                        let dateError = ErrorDateFormat.dateError
                        print(dateError)
                    }
                }
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self, userInfo: [ImagesListService.userInfoKey: self.photos])
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
        let completionHandler = { [weak self] (result: Result <Void, Error>)  in
            guard let self = self else { return }
            switch result {
            case .success(_):
                self.convertIsLike(photoId: photoId)
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        if isLike {
            self.deleteLike(photoId: photoId, completion: completionHandler)
        } else {
            self.putLike(photoId: photoId, completion: completionHandler)
        }
    }
}

private extension ImagesListService {
    //MARK: Delete Put Like
    func deleteLike(photoId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard deleteTask == nil else { return }
        var request: URLRequest?
        do { let requestForLike = try imageListServiceRequestForLike(photoId: photoId, isLike: Constants.isFalse)
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
    
    func putLike(photoId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard putLikeTask == nil else { return }
        var request: URLRequest?
        do {
            let putLikeRequest = try imageListServiceRequestForLike(photoId: photoId, isLike: Constants.isTrue)
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
            case .success(_):
                completion(.success(Void()))
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
        component.queryItems = [URLQueryItem(name: ImagesListService.pageString, value: "\(page)")]
        component.path = ImagesListService.path
        guard let url = component.url else { throw NetworkError.urlComponentsError}
        
        guard let token = OAuth2TokenKeychainStorage().getToken() else { throw KeychainError.errorStorageToken}
        let bearerToken = "\(ConstantsUnSplash.bearer) \(token)"
        
        return URLRequest.makeHTTPRequestForModel(url: url, bearerToken: bearerToken, forHTTPHeaderField: ConstantsUnSplash.hTTPHeaderField)
    }
    
    //TODO: Image List Service For Like Request
    func imageListServiceRequestForLike(photoId: String, isLike: Bool) throws -> URLRequest {
        guard var component = component else { throw NetworkError.urlComponentsError }
        let path = "\(ImagesListService.path)\(photoId)\(ImagesListService.likeString)"
        component.path = path
        guard let url = component.url else { throw NetworkError.urlComponentsError }
        
        guard let token = OAuth2TokenKeychainStorage().getToken() else { throw KeychainError.errorStorageToken}
        let bearerToken = "\(ConstantsUnSplash.bearer) \(token)"
        
        if isLike {
            return URLRequest.makeHTTPRequestForToken(url: url, bearerToken: bearerToken, forHTTPHeaderField: ConstantsUnSplash.hTTPHeaderField, httpMethod: ConstantsUnSplash.httpMethodPost)
        } else {
            return URLRequest.makeHTTPRequestForToken(url: url, bearerToken: bearerToken, forHTTPHeaderField: ConstantsUnSplash.hTTPHeaderField, httpMethod: ConstantsUnSplash.httpMethodDelete)
        }
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
    func convertModel(model: PhotoResult) throws -> Photo {
        let id = model.id ?? Constants.emptyLine
        let heigt = model.height ?? ImagesListService.sizeDefault.heigt
        let width = model.width ?? ImagesListService.sizeDefault.width
        let size = CGSize(width: width, height: heigt)
        let welcomeDescription = model.description
        let thumbImageURL = model.urls?.thumb ?? Constants.emptyLine
        let largeImageURL = model.urls?.regular ?? Constants.emptyLine
        let isLiked = model.likedByUser ?? Constants.isFalse
        let createDate: Date
        do { let createdAt = try dateFormatter.setupModelDate(createAt: model.createdAt)
            createDate = createdAt
        }
        catch {
            let dateError = ErrorDateFormat.dateError
            throw dateError
        }
        
        let photoModel = Photo(id: id,
                               size: size,
                               createdAt: createDate,
                               welcomeDescription: welcomeDescription,
                               thumbImageURL: thumbImageURL,
                               largeImageURL: largeImageURL,
                               isLiked: isLiked)
        return photoModel
    }
}
