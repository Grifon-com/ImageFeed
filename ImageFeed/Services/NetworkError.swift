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
}
