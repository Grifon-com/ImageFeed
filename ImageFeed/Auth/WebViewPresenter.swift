//
//  WebViewPresenter.swift
//  ImageFeed
//
//  Created by Григорий Машук on 4.08.23.
//

import Foundation

public protocol WebViewPresenterProtocol {
    var view: WebViewViewControllerProtocol? { get set }
    var estimatedProgressObservation: NSKeyValueObservation? { get set }
    func viewDidLoad()
    func didUpdateProgressValue(_ newValue: Double)
    func code(from url: URL) -> String?
}

final class WebViewPresenter: WebViewPresenterProtocol {
    weak var view: WebViewViewControllerProtocol?
    var estimatedProgressObservation: NSKeyValueObservation?
    let authConfiguration: AuthConfiguration
    var authHelper: AuthHelperProtocol
    
    init(authConfiguration: AuthConfiguration = .standard, authHelper: AuthHelperProtocol) {
        self.authConfiguration = authConfiguration
        self.authHelper = authHelper
    }
    
    func viewDidLoad() {
        guard let view else { return }
        let request = authHelper.authRequest()
        view.load(request: request)
        didUpdateProgressValue(0)
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
        guard let view else { return }
        let newProgressValue = Float(newValue)
        view.setProgressValue(newProgressValue)
        
        let shouldHideProgress = shouldHideProgress(for: newProgressValue)
        view.setProgressHidden(shouldHideProgress)
    }
    
    func shouldHideProgress(for value: Float) -> Bool {
        abs(value - 1.0) <= 0.0001
    }
    
    func code(from url: URL) -> String? {
        authHelper.code(from: url)
    }
}
