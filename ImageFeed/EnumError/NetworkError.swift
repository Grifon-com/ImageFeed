//
//  Errors.swift
//  ImageFeed
//
//  Created by Григорий Машук on 7.07.23.
//

import Foundation

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case urlError
    case urlComponentsError
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        true
    }
}
