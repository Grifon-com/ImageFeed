//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Григорий Машук on 22.06.23.
//

import UIKit

let AccessKey = "LT6B1zlWM3KVZlUOpvTTGCoCJJNdB7kOuornZ5RL6p8"
let SecretKey = "O6kwIqpod1px48XTGR4tEL-evSst2nCYPUJDSgU-dZA"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"
let DefaultBaseURL = "https://unsplash.com"
let UnSplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
let ScopeString = "scope"
let ResponseTypeString = "response_type"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let authURLString: String
    let defaultBaseURL: String
    let scopeString: String
    let responseTypeString: String
    
    static var standard: AuthConfiguration {
        AuthConfiguration(accessKey: AccessKey,
                          secretKey: SecretKey,
                          redirectURI: RedirectURI,
                          accessScope: AccessScope,
                          defaultBaseURL: DefaultBaseURL,
                          authURLString: UnSplashAuthorizeURLString,
                          scopeString: ScopeString,
                          responseTypeString: ResponseTypeString)
    }
    
    init(accessKey: String,
         secretKey: String,
         redirectURI: String,
         accessScope: String,
         defaultBaseURL: String,
         authURLString: String,
         scopeString: String,
         responseTypeString: String) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
        self.scopeString = scopeString
        self.responseTypeString = responseTypeString
    }
}


