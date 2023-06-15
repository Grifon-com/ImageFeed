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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let cellGradienView = UIView()
        let layer =  cellGradienView.addGradientBackground(firstColor: .ypBlue, secondColor: .ypRed)
        cellGradienView.layer.insertSublayer(layer, at: 0)
        cellGradienView.layoutIfNeeded()
        self.cellGradienView = cellGradienView
    }
    
    override func awakeFromNib() {
       super.awakeFromNib()
        let layer =  cellGradienView.addGradientBackground(firstColor: .ypBlue, secondColor: .ypRed)
        cellGradienView.layer.insertSublayer(layer, at: 0)
        cellGradienView.layoutIfNeeded()
    }
}

extension UIView{
    func addGradientBackground(firstColor: UIColor, secondColor: UIColor) -> CAGradientLayer{
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
        return gradientLayer
    }
}
