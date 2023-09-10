//
//  FormatDate.swift
//  ImageFeed
//
//  Created by Григорий Машук on 31.07.23.
//

import Foundation

public protocol FormatDateProtocol {
    func setupModelDate(createAt: String?) -> Date?
    func setupUIDateString(date: Date?) -> String?
}

final class FormatDate: FormatDateProtocol {
    static let shared = FormatDate()
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter
    }()
    
    private lazy var iSO8601DateFormatter: ISO8601DateFormatter = {
        let iSO8601DateFormatter = ISO8601DateFormatter()
        
        return iSO8601DateFormatter
    }()
    
    func setupModelDate(createAt: String?) -> Date? {
        iSO8601DateFormatter.date(from: createAt ?? ConstantsImageFeed.emptyLine)
    }
    
    func setupUIDateString(date: Date?) -> String? {
        guard let date = date else { return ConstantsImageFeed.emptyLine }
        return dateFormatter.string(from: date)
    }
}
