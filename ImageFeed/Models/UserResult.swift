//
//  UserResult.swift
//  ImageFeed
//
//  Created by Григорий Машук on 10.07.23.
//

import Foundation
struct UserResult: Codable {
    let profileImage: ImageURL
    
    struct ImageURL: Codable {
        let small: String?
    }
}


