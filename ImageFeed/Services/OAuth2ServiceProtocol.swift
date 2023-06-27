//
//  OAuth2ServiceProtocol.swift
//  ImageFeed
//
//  Created by Григорий Машук on 26.06.23.
//

import Foundation

protocol OAuth2ServiceProtocol {
    func fetchAuthToken(_ code: String, complition: @escaping (Result <String, Error>) -> Void)
}
