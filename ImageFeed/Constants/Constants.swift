//
//  Constants.swift
//  ImageFeed
//
//  Created by Григорий Машук on 22.06.23.
//

import UIKit

enum ConstantsUnSplash {
    static let accessKey = "LT6B1zlWM3KVZlUOpvTTGCoCJJNdB7kOuornZ5RL6p8"
    static let secretKey = "O6kwIqpod1px48XTGR4tEL-evSst2nCYPUJDSgU-dZA"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    static let defaultBaseURL = "https://unsplash.com"
    static let jsonDefaultBaseURL = "https://api.unsplash.com"
    static let unSplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let authNativePath = "/oauth/authorize/native"
    static let pathToken = "/oauth/token"
    
    static let code = "code"
    static let bearer = "Bearer"
    static let hTTPHeaderField = "Authorization"
    static let redirectUriString = "redirect_uri"
    static let clientIdString = "client_id"
    
    static let postHTTPMethod = "POST"
    static let deleteHTTPMethod = "DELETE"
}

enum Constants {
    static let emptyLine = ""
}

enum ConstantsSceneConfiguration {
    static let name = "Main"
}

enum ConstantsBool {
    static let isFalse = false
    static let isTrue = true
}

enum ConstantsImage {
    static let imageLike = UIImage(named: "ActiveLike")
    static let imageNoLike = UIImage(named:"NoActiveLike")
}

