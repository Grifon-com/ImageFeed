//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Григорий Машук on 3.07.23.
//

import Foundation

struct OAuthTokenResponseBody: Codable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
