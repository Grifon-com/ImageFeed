//
//  CleanManager.swift
//  ImageFeed
//
//  Created by Григорий Машук on 31.07.23.
//

import Foundation
import WebKit

protocol CleanManagerProtocol {
    func cleanCookies()
    func cleanToken()
}

final class CleanManager: CleanManagerProtocol {    
    private let tokenStorage: OAuth2TokenKeychainStorageProtocol
    
    init(tokenStorage: OAuth2TokenKeychainStorageProtocol) {
        self.tokenStorage = tokenStorage
    }
    
    func cleanCookies() {
        // Очищаем все куки из хранилища.
        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
        // Запрашиваем все данные из локального хранилища.
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { record in
            // Массив полученных записей удаляем из хранилища.
            record.forEach { record in
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
            }
        }
    }
    
    func cleanToken() {
        // удаляем токен из KeyChain
        tokenStorage.removeSuccessful()
    }
}
