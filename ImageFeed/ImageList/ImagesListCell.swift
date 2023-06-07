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
    @IBOutlet weak var cellGradientView: UIView!
    
    static let reuseIdentifier = "ImagesListCell"
    
    func setupGradient() {
        let gradient = CAGradientLayer()
        
        gradient.colors = [UIColor.ypRed.cgColor, UIColor.ypBlue.cgColor]
        
        gradient.frame = cellGradientView.bounds
        
        cellGradientView.layer.addSublayer(gradient)
        
        gradient.startPoint = CGPoint(x: 0.5, y: 0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
    }
}

