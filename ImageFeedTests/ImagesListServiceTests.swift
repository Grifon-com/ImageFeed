//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Григорий Машук on 24.07.23.
//

@testable import ImageFeed
import XCTest

final class ImagesListServiceTests: XCTestCase {
    func testExample() {
        let service = ImagesListService()
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName:ImagesListService.didChangeNotification,
            object: nil,
            queue: .main) { _ in
                expectation.fulfill()
            }
        service.fetchPhotosNextPage()
        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(service.photos.count, 10)
    }
}
