//
//  Extensions.swift
//  ImageFeed
//
//  Created by Григорий Машук on 10.07.23.
//

import Foundation

extension URLRequest {
    static func makeHTTPRequestForModel(url: URL, bearerToken: String, forHTTPHeaderField: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.setValue(bearerToken, forHTTPHeaderField: forHTTPHeaderField)
        return request
    }
    
    static func makeHTTPRequest(url: URL, httpMethod: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
    
    static func makeHTTPRequestForToken(url: URL, bearerToken: String, forHTTPHeaderField: String, httpMethod: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue(bearerToken, forHTTPHeaderField: forHTTPHeaderField)
        return request
    }
}
