//
//  ImagesListConfiguration.swift
//  ImageFeed
//
//  Created by Григорий Машук on 8.08.23.
//

import UIKit

let CellReuseIdentifier = "ImagesListCell"
let CellViewIndents = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
let TableViewContentInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
let Null: Int = 0
let CellImageCornerRadius: Double = 16
let Placeholder = "placeholderCell"

public struct ImagesListConfiguration {
    let cellReuseIdentifier: String
    let tableViewContentInsets: UIEdgeInsets
    let cellViewIndents: UIEdgeInsets
    let null: Int
    let CcellImageCornerRadius: Double
    let placeholder: String
    
    init(cellReuseIdentifier: String, tableViewContentInsets: UIEdgeInsets, cellViewIndents: UIEdgeInsets, null: Int, CcellImageCornerRadius: Double, placeholder: String) {
        self.cellReuseIdentifier = cellReuseIdentifier
        self.tableViewContentInsets = tableViewContentInsets
        self.cellViewIndents = cellViewIndents
        self.null = null
        self.CcellImageCornerRadius = CcellImageCornerRadius
        self.placeholder = placeholder
    }
    
    static var standart: ImagesListConfiguration {
        ImagesListConfiguration(cellReuseIdentifier: CellReuseIdentifier,
                                tableViewContentInsets: TableViewContentInsets,
                                cellViewIndents: CellViewIndents,
                                null: Null,
                                CcellImageCornerRadius: CellImageCornerRadius,
                                placeholder: Placeholder)
    }
}
