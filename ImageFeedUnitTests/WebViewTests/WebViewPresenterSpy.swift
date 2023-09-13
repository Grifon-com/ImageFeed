//
//  WebViewPresenterSpy.swift
//  ImageFeedTests
//
//  Created by Григорий Машук on 4.08.23.
//

import ImageFeed
import Foundation

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var estimatedProgressObservation: NSKeyValueObservation?
    
    var viewDidLoadCalled: Bool = false
    var view: ImageFeed.WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {}
    
    func code(from url: URL) -> String? {
        nil
    }
}
