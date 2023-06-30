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
    private enum Keys: String {
        case token
    }
    
    private let userDefault = UserDefaults.standard
    
    var token: String? {
        get {
            let token = userDefault.string(forKey: Keys.token.rawValue) ?? nil
            return token
        }
        set {
            userDefault.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
