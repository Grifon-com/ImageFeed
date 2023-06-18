//
//  ExtensionDate.swift
//  ImageFeed
//
//  Created by Марина Машук on 17.06.23.
//

import Foundation

private var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter
}()

extension Date {
    var dateTimeString: String { dateFormatter.string(from: self)}
}
