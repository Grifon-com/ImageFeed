//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Григорий Машук on 27.05.23.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var cellButton: UIButton!
    @IBOutlet private weak var cellLabel: UILabel!
    
    static let reuseIdentifier = "ImagesListCell"
    
    func configure(model: ImagesListCellModel) {
        cellImage.image = model.image
        cellButton.imageView?.image = model.buttonImage
        cellLabel.text = model.textLabel
        }
}

