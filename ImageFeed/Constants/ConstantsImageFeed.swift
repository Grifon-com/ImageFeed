//
//  Constants.swift
//  ImageFeed
//
//  Created by Григорий Машук on 22.06.23.
//

import UIKit

struct ConstantsImageFeed {
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

    static let emptyLine = ""

    static let name = "Main"

    static let isFalse = false
    static let isTrue = true

    static let imageLike = UIImage(named: "ActiveLike")
    static let imageNoLike = UIImage(named:"NoActiveLike")

    static let alertTitle = "Что-то пошло не так("
    static let alertMessage = "Не удалось войти в систему"
    static let alertActionTitle = "OK"
}
