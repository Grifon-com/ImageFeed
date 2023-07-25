//
//  PhotoModel.swift
//  ImageFeed
//
//  Created by Марина Машук on 23.07.23.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
}
