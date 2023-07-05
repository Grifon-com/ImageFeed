//
//  TokenStorage.swift
//  ImageFeed
//
//  Created by Марина Машук on 5.07.23.
//

import Foundation
protocol Storage {
    var token: String? { get set }
}

private enum Key: String {
    case token
}

struct TokenStorage: Storage {
    let userDefaults = UserDefaults.standard
    
    var token: String? {
        get { userDefaults.string(forKey: Key.token.rawValue) }
        set { userDefaults.set(newValue, forKey: Key.token.rawValue) }
    }
}
