//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Марина Машук on 4.08.23.
//

import ImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var estimatedProgressObservation: NSKeyValueObservation?
    
    var viewDidLoadeCalled: Bool = false
    var view: ImageFeed.WebViewViewControllerProtocol?
    
    func viewDidload() {
        viewDidLoadeCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {}
    
    func code(from url: URL) -> String? {
        nil
    }
}
