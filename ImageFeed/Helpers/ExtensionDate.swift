////
////  ExtensionDate.swift
////  ImageFeed
////
////  Created by Марина Машук on 17.06.23.
////
//
////import Foundation
////
////private var dateFormatter: DateFormatter = {
////    let formatter = DateFormatter()
////    formatter.dateStyle = .long
////    formatter.timeStyle = .none
////    return formatter
////}()
////
////extension Date {
////    var dateTimeString: String { dateFormatter.string(from: self)}
////}
//
//
////
////  File.swift
////  TableViewUpdates
////
////  Created by Марина Машук on 31.07.23.
////
//
//import Foundation
//
//
//
//
//
//
////
////  Clear.swift
////  ImageFeed
////
////  Created by Марина Машук on 31.07.23.
////
//
//import Foundation
////import WebKit
////
////protocol CleanProtocol {
////    func cleanCookies()
////    func cleanToken()
////}
////
////final class Clean: CleanProtocol {
////    private let tokenStorage = OAuth2TokenKeychainStorage()
////    
////    func cleanCookies() {
////        // Очищаем все куки из хранилища.
////        HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
////        // Запрашиваем все данные из локального хранилища.
////        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { record in
////            // Массив полученных записей удаляем из хранилища.
////            record.forEach { record in
////                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
////            }
////        }
////    }
////    
////    func cleanToken() {
////        // удаляем токен из KeyChain
////        tokenStorage.removeSuccessful()
////    }
////}
//
//
////
////  DateError.swift
////  ImageFeed
////
////  Created by Григорий Машук on 31.07.23.
////
//
//import Foundation
//
//enum DateFormatError: Error {
//    case dateError
//}
//
//
//
////
////  DateResume.swift
////  ImageFeed
////
////  Created by Григорий Машук on 31.07.23.
////
//
//import Foundation
//
//final class DateResume {
//    let shared = DateResume()
//    
//    private lazy var dateFormatter: DateFormatter = {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .none
//        return dateFormatter
//    }()
//    
//    private lazy var iSO8601DateFormatter: ISO8601DateFormatter = {
//        let iSO8601DateFormatter = ISO8601DateFormatter()
//        
//        return iSO8601DateFormatter
//    }()
//    
//    func setupModelDate(createAt: String?) throws -> Date {
//        guard let createAt = createAt,
//              let date = iSO8601DateFormatter.date(from: createAt) else { throw  ErrorDateFormat.dateError}
//        return date
//    }
//    
//    func setupUIDateString(date: Date) -> String {
//        let date = dateFormatter.string(from: date)
//        
//        return date
//    }
//}
//
//
//
//
