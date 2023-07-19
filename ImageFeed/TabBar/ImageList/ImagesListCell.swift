//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Григорий Машук on 27.05.23.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    private var cellImage: UIImageView = {
        let cellImage = UIImageView()
        cellImage.layer.masksToBounds = true
        cellImage.layer.cornerRadius = 16
        
        return cellImage
    }()
    
    private var cellButton: UIButton = {
        let cellButton = UIButton()
        let image = UIImage(named: "Active")
        cellButton.setImage(image, for: .normal)
        
        return cellButton
    }()
    
    private var cellLabel: UILabel = {
        let cellLabel = UILabel()
        cellLabel.font = UIFont.systemFont(ofSize: 13)
        cellLabel.textColor = .ypWhite
        
        return cellLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubView()
        applyConstraints()
        self.backgroundColor = .clear
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
    private func setupSubView() {
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
