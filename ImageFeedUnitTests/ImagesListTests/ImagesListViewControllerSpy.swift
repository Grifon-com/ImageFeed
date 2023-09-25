//
//  ImagesListViewControllerSpy.swift
//  ImagesListTests
//
//  Created by Григорий Машук on 9.08.23.
//

@testable import ImageFeed
import UIKit

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var updateTableViewAnimatedCalled = false
    var presenter: ImageFeed.ImagesListPresenterProtocol?
    var photos: [ImageFeed.Photo] = []
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
}
