//
//  ImagesListHelper.swift
//  ImageFeed
//
//  Created by Григорий Машук on 8.08.23.
//

import UIKit

protocol ImagesListHelperProtocol {
    func didModel(photo: Photo) -> ImagesListCellModel
    func cellHeightCalculation(imageSize: CGSize, indents: UIEdgeInsets, tableView: UITableView) -> CGFloat
}

final class ImagesListHelper: ImagesListHelperProtocol {
    var dateFarmatter: FormatDateProtocol
    
    init(dateFarmatter: FormatDateProtocol = FormatDate.shared) {
        self.dateFarmatter = dateFarmatter
    }
    
    func didModel(photo: Photo) -> ImagesListCellModel {
        let isLike = photo.isLiked
        let textLabel: String = dateFarmatter.setupUIDateString(date: photo.createdAt) ?? ConstantsImageFeed.emptyLine
        let buttonImage = isLike ? ConstantsImageFeed.imageLike: ConstantsImageFeed.imageNoLike
        let model = ImagesListCellModel(buttonImage: buttonImage, textLabel: textLabel)
        
        return model
    }
    
    func cellHeightCalculation(imageSize: CGSize, indents: UIEdgeInsets, tableView: UITableView) -> CGFloat {
        let widthImageView = tableView.bounds.width - indents.left - indents.right
        let widthImage = imageSize.width
        let coefficient = widthImageView / widthImage
        let heightImageView = imageSize.height * coefficient + indents.top + indents.bottom
        
        return heightImageView
    }
    
}
