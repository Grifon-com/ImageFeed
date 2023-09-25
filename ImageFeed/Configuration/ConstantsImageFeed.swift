//
//  Constants.swift
//  ImageFeed
//
//  Created by Григорий Машук on 7.09.23.
//

import UIKit

enum ConstantsImageFeed {
    static let jsonDefaultBaseURL = "https://api.unsplash.com"
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
    
    static let webViewImageBackButton = "nav_back_button"
    static let webViewIdentifier = "UnsplashWebView"
    
    static let authButtonIdentifier = "Authenticate"
    static let profileLogoutButtonIdentifier = "logoutButton"
}
