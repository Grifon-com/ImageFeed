//
//  AuthHelper.swift
//  ImageFeed
//
//  Created by Григорий Машук on 4.08.23.
//

import Foundation

protocol AuthHelperProtocol {
    func authRequest() -> URLRequest
    func code(from url: URL) -> String?
}

final class AuthHelper: AuthHelperProtocol {
    private let configuration: AuthConfiguration
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
    }
    
    func authRequest() -> URLRequest {
        let url = authURL()
        return URLRequest(url: url)
    }
    
    func code(from url: URL) -> String? {
        if let urlComponents = URLComponents(string: url.absoluteString),
           urlComponents.path == ConstantsImageFeed.authNativePath,
           let items = urlComponents.queryItems,
           let codeItem = items.first(where: { $0.name == ConstantsImageFeed.code}) {
            
            return codeItem.value
        } else {
            return nil
        }
    }
    
    func authURL() -> URL {
       var urlComponents = URLComponents(string: configuration.authURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: ConstantsImageFeed.clientIdString, value: configuration.accessKey),
            URLQueryItem(name: ConstantsImageFeed.redirectUriString, value: configuration.redirectURI),
            URLQueryItem(name: configuration.responseTypeString, value: ConstantsImageFeed.code),
            URLQueryItem(name: configuration.scopeString, value: configuration.accessScope)
        ]
        return urlComponents.url!
    }
}
