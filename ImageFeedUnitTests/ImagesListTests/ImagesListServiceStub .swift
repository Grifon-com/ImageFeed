//
//  ImagesListServiceStub .swift
//  ImagesListTests
//
//  Created by Григорий Машук on 9.09.23.
//

import Foundation
import ImageFeed

final class ImagesListServiceStub: ImagesListServiceProtocol {
    var photos: [ImageFeed.Photo] = []
    
    func fetchPhotosNextPage() {
        let photo = Photo(id: "test",
                          size: CGSize(width: 5, height: 5),
                          createdAt: nil,
                          welcomeDescription: nil,
                          thumbImageURL: "https://api.unsplash.com",
                          largeImageURL: "https://api.unsplash.com",
                          isLiked: true)
        photos.append(photo)
    }
    
    func chengeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {}
}
