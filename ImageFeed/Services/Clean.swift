//
//  Clean.swift
//  ImageFeed
//
//  Created by Григорий Машук on 31.07.23.
//

import Foundation
import WebKit

protocol CleanProtocol {
    func cleanCookies()
    func cleanToken()
}

final class Clean: CleanProtocol {    
    private let tokenStorage = OAuth2TokenKeychainStorage()
    
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
