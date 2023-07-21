//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Григорий Машук on 27.05.23.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    private static let imageLikeName = "Active"
    private static let cornerRadiusCellImage = CGFloat(16)
    private static let fontCellLabel = CGFloat(13)
    static let reuseIdentifier = "ImagesListCell"
    
    private lazy var cellImage: UIImageView = {
        let cellImage = UIImageView()
        cellImage.layer.masksToBounds = true
        cellImage.layer.cornerRadius = ImagesListCell.cornerRadiusCellImage
        
        return cellImage
    }()
    
    private lazy var cellButton: UIButton = {
        let cellButton = UIButton()
        let image = UIImage(named: ImagesListCell.imageLikeName)
        cellButton.setImage(image, for: .normal)
        
        return cellButton
    }()
    
    private lazy var cellLabel: UILabel = {
        let cellLabel = UILabel()
        cellLabel.font = UIFont.systemFont(ofSize: ImagesListCell.fontCellLabel)
        cellLabel.textColor = .ypWhite
        
        return cellLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUIElement()
        applyConstraints()
        
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(model: ImagesListCellModel) {
        cellImage.image = model.image
        cellButton.imageView?.image = model.buttonImage
        cellLabel.text = model.textLabel
    }
}

//MARK: - SetupUIElement
private extension ImagesListCell {
    private func setupUIElement() {
        self.backgroundColor = .clear
        [cellImage, cellButton, cellLabel].forEach {
            self.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
        }
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            cellImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            cellImage.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            cellImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            cellImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            cellButton.heightAnchor.constraint(equalToConstant: 44),
            cellButton.widthAnchor.constraint(equalToConstant: 44),
            cellButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            cellButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            
            cellLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12),
            cellLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 24)
        ])
    }
}
