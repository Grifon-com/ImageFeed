//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Григорий Машук on 27.05.23.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellButton: UIButton!
    @IBOutlet weak var cellLable: UILabel!
    @IBOutlet weak var cellGradienView: UIView!
    
    let gradientLayer = CAGradientLayer()
    static let reuseIdentifier = "ImagesListCell"
    
    func setupGaradient() {
        gradientLayer.colors = [UIColor.ypRed.cgColor, UIColor.ypBlue.cgColor]
        cellGradienView.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradientLayer.frame = cellGradienView.bounds
    }
}

