//
//  FormatDate.swift
//  ImageFeed
//
//  Created by Григорий Машук on 31.07.23.
//

import Foundation

final class FormatDate {
    let shared = FormatDate()

    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter
    }()

    private lazy var iSO8601DateFormatter: ISO8601DateFormatter = {
        let iSO8601DateFormatter = ISO8601DateFormatter()

        return iSO8601DateFormatter
    }()

    func setupModelDate(createAt: String?) throws -> Date {
        guard let createAt = createAt,
              let date = iSO8601DateFormatter.date(from: createAt) else { throw  ErrorDateFormat.dateError}
        return date
    }

    func setupUIDateString(date: Date) -> String {
        let date = dateFormatter.string(from: date)

        return date
    }
}
