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
    private static let isLikedDefault = false
    private static let sizeDefault = (heigt: 0, width: 0)
    private static let userInfoKey = "listPhoto"
    private static let pageString = "page"
    private static let path = "/photos"
    static let didChangeNotification = Notification.Name("ImageListServiceDidChange")
    
    static let shared = ImagesListService()
    
    private (set) var photos: [Photo] = []
    
    private (set) var lastLoadedPage: Int?
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var token: String?
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        guard task == nil else { return }
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        lastLoadedPage = nextPage
        var request: URLRequest?
        do { let modelRequest = try imageListServiceRequest(page: nextPage)
            request = modelRequest
        }
        catch {
            let errorRequest = NetworkError.urlComponentsError
        }
        guard let request = request else { return }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result <[PhotoResult], Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                model.forEach {
                    let photoModel = self.convertModel(model: $0)
                    self.photos.append(photoModel)
                    print(self.photos.count)
                }
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self, userInfo: [ImagesListService.userInfoKey: self.photos])
                self.task = nil
            case .failure(let error):
                //TODO: DELETE
                print(error)
            }
        }
        self.task = task
        task.resume()
    }
}

private extension ImagesListService {
    func imageListServiceRequest(page: Int) throws -> URLRequest {
        guard var component = URLComponents(string: ConstantsUnSplash.jsonDefaultBaseURL) else { throw NetworkError.urlComponentsError}
        component.queryItems = [
            URLQueryItem(name: ImagesListService.pageString, value: "\(page)")
        ]
        component.path = ImagesListService.path
        guard let url = component.url else { throw NetworkError.urlComponentsError}
        guard let token = OAuth2TokenKeychainStorage().getToken() else { throw KeychainError.errorStorageToken}
        let bearerToken = "\(ConstantsUnSplash.bearer) \(token)"
        
        return URLRequest.makeHTTPRequestForModel(url: url, bearerToken: bearerToken, forHTTPHeaderField: ConstantsUnSplash.hTTPHeaderField)
    }
    
    func convertModel(model: PhotoResult) -> Photo {
        let id = model.id ?? Constants.emptyLine
        let heigt = model.height ?? ImagesListService.sizeDefault.heigt
        let width = model.width ?? ImagesListService.sizeDefault.width
        let size = CGSize(width: width, height: heigt)
        let createdAt = model.createdAt
        let welcomeDescription = model.description
        let thumbImageURL = model.urls.thumb ?? Constants.emptyLine
        let largeImageURL = model.urls.regular ?? Constants.emptyLine
        let isLiked = model.likedByUser ?? ImagesListService.isLikedDefault
        
        let photoModel = Photo(id: id,
                               size: size,
                               createdAt: createdAt,
                               welcomeDescription: welcomeDescription,
                               thumbImageURL: thumbImageURL,
                               largeImageURL: largeImageURL,
                               isLiked: isLiked)
        return photoModel
    }
}
