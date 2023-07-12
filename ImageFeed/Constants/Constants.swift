//
//  Constants.swift
//  ImageFeed
//
//  Created by Григорий Машук on 22.06.23.
//

import Foundation

enum ConstantsUnSplash {
    static let accessKey = "LT6B1zlWM3KVZlUOpvTTGCoCJJNdB7kOuornZ5RL6p8"
    static let secretKey = "O6kwIqpod1px48XTGR4tEL-evSst2nCYPUJDSgU-dZA"
    static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    static let defaultBaseURL: URL = URL(string: "https://unsplash.com")!
    static let jsondefaultBaseURL: URL = URL(string: "https://api.unsplash.com")!
    static let unSplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    static let authNativePath = "/oauth/authorize/native"
    static let path = "/oauth/token"
    static let code = "code"
    static let bearer = "Bearer"
    static let hTTPHeaderField = "Authorization"
    
}



