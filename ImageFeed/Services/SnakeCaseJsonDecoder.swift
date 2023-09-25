//
//  SnakeCaseJsonDecoder.swift
//  ImageFeed
//
//  Created by Григорий Машук on 7.07.23.
//

import Foundation

final class SnakeCaseJsonDecoder: JSONDecoder {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
    }
}
