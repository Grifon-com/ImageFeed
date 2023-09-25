//
//  ImagesListServiceStub .swift
//  ImagesListTests
//
//  Created by Григорий Машук on 9.09.23.
//

import Foundation
@testable import ImageFeed

final class ImagesListServiceStub: ImagesListServiceProtocol {
    let photo = Photo(id: "test",
                      size: CGSize(width: 5, height: 5),
                      createdAt: nil,
                      welcomeDescription: nil,
                      thumbImageURL: "https://api.unsplash.com",
                      largeImageURL: "test",
                      isLiked: true)
    
    var photos: [ImageFeed.Photo] = [Photo(id: "test",
                                           size: CGSize(width: 5, height: 5),
                                           createdAt: nil,
                                           welcomeDescription: nil,
                                           thumbImageURL: "https://api.unsplash.com",
                                           largeImageURL: "",
                                           isLiked: true)]
    
    func fetchPhotosNextPage() {
        photos.append(photo)
    }
    
    func chengeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {}
}
