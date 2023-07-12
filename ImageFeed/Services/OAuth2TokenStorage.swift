//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Григорий Машук on 25.06.23.
//

import Foundation

protocol StorageTokenProtocol {
    var token: String? { get set }
}

final class OAuth2TokenStorage: StorageTokenProtocol {
    static let shared = OAuth2TokenStorage()
    
    private enum Keys: String {
        case token
    }
    
    private let userDefault = UserDefaults.standard
    
    var token: String? {
        get {
            userDefault.string(forKey: Keys.token.rawValue)
        }
        set {
            userDefault.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
