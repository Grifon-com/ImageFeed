//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Григорий Машук on 23.07.23.
//

import Foundation

struct PhotoResult: Codable {
    let id: String?
    let createdAt: String?
    let width: Int?
    let height: Int?
    let likedByUser: Bool?
    let description: String?
    let urls: Urls
    
    struct Urls: Codable {
        let regular: String?
        let thumb: String?
    }
}


