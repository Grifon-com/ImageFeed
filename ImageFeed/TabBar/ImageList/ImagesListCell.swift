//
//  ImageListCell.swift
//  ImageFeed
//
//  Created by Григорий Машук on 27.05.23.
//

import UIKit
import Kingfisher

protocol ImageListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    private static let cornerRadiusCellImage = CGFloat(16)
    private static let fontCellLabel = CGFloat(13)
    static let reuseIdentifier = "ImagesListCell"
    
    weak var delegate: ImageListCellDelegate?
    
    lazy var cellImageView: UIImageView = {
        let cellImage = UIImageView()
        cellImage.layer.masksToBounds = true
        cellImage.layer.cornerRadius = ImagesListCell.cornerRadiusCellImage
        
        return cellImage
    }()
    
    private lazy var cellButton: UIButton = {
        let cellButton = UIButton()
        cellButton.addTarget(nil, action: #selector(likeButtonClicked), for: .allTouchEvents)
        
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
}

private extension ImagesListCell {
    //MARK: Button Action
    @objc
    func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    //MARK: SetupUIElement
    func setupUIElement() {
        self.backgroundColor = .clear
        [cellImageView, cellButton, cellLabel].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
        }
        cellButton.translatesAutoresizingMaskIntoConstraints = false
        cellButton.backgroundColor = .clear
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            cellImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            cellImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            cellImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            cellImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            
            cellButton.heightAnchor.constraint(equalToConstant: 44),
            cellButton.widthAnchor.constraint(equalToConstant: 44),
            cellButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            cellButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16),
            
            cellLabel.bottomAnchor.constraint(equalTo: cellImageView.bottomAnchor, constant: -8),
            cellLabel.leftAnchor.constraint(equalTo: cellImageView.leftAnchor, constant: 8)
        ])
    }
}

extension ImagesListCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Отменяем загрузку, чтобы избежать багов при переиспользовании ячеек
        cellImageView.kf.cancelDownloadTask()
    }
    
    func configure(model: ImagesListCellModel) {
        cellButton.setImage(model.buttonImage, for: .normal)
        cellLabel.text = model.textLabel
    }
    
    //MARK: Set is Liked
    func setIsLiked(isLike: Bool) {
        let imageButton = isLike ? ConstantsImage.imageLike : ConstantsImage.imageNoLike
        cellButton.setImage(imageButton, for: .normal)
    }
}
