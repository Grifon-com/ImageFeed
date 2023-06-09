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
    
    static let reuseIdentifier = "ImagesListCell"
    
    override func awakeFromNib() {
       super.awakeFromNib()
        cellGradienView.addGradientBackground(firstColor: .ypBlue, secondColor: .ypRed)
    }
}

extension UIView{
    func addGradientBackground(firstColor: UIColor, secondColor: UIColor){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        self.layer.addSublayer(gradientLayer)
    }
}
