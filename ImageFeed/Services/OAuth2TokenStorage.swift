//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Марина Машук on 25.06.23.
//

import Foundation

protocol TokenProtocol {
    var token:String { get set }
}

final class OAuth2TokenStorage: TokenProtocol {
    private enum Keys: String {
        case token
    }
    
    private let userDefault = UserDefaults.standard
    
    var token: String {
        get {
            let token = userDefault.string(forKey: Keys.token.rawValue) ?? ""
            return token
        }
        set {
            userDefault.set(newValue, forKey: Keys.token.rawValue)
        }
    }
}
