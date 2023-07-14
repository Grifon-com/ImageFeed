//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Григорий Машук on 25.06.23.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenKeycheinStorage {    
    private enum Key: String {
        case token
    }
    
    private var token: String? {
        get {
            KeychainWrapper.standard.string(forKey: Key.token.rawValue)
        }
        set {}
    }
    
    func getToken() -> String? {
        token
    }
    
    func storageToken(newToken: String?) throws {
        guard let newToken = newToken else { return }
        let isSucsses = KeychainWrapper.standard.set(newToken, forKey: Key.token.rawValue)
        guard isSucsses else { throw KeycheynError.errorStorageToken }
    }
    
    func removeSuccessful() {
        KeychainWrapper.standard.removeObject(forKey: Key.token.rawValue)
    }
    
}
