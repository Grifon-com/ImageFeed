//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Григорий Машук on 24.06.23.
//

import Foundation

protocol OAuth2ServiceProtocol: AnyObject {
    func fetchAuthToken(_ code: String, completion: @escaping (Result <String, Error>) -> Void)
}

final class OAuth2Service: OAuth2ServiceProtocol {
    private static let shared = OAuth2Service()
    
    private static let httpMethod = "POST"
    private static let clientIdString = "client_id"
    private static let clientSecretString = "client_secret"
    private static let redirectUriString = "redirect_uri"
    private static let codeString = "code"
    private static let grantTypeString = "grant_type"
    private static let authorizationCodeString = "authorization_code"
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private (set) var authToken: String? {
        get { return OAuth2TokenStorage().token}
        set { OAuth2TokenStorage().token = newValue }
    }
    
    func fetchAuthToken(_ code: String, completion: @escaping (Result <String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        let request = authTokenRequest(code: code)
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                completion(.success(authToken))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.lastCode = nil
            }
        }
        task.resume()
    }
}

private extension OAuth2Service {
    private func object(for request: URLRequest, completion: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        let decoder = SnakeCaseJsonDecoder()
        return urlSession.data(for: request) {(result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            completion(response)
        }
    }
    
    private func authTokenRequest(code: String) -> URLRequest {
        let urlAbsoluteString = ConstantsUnSplash.defaultBaseURL.absoluteString + ConstantsUnSplash.path
        var urlComponents = URLComponents(string: urlAbsoluteString)!
        
        urlComponents.queryItems = [
            URLQueryItem(name: OAuth2Service.clientIdString, value: ConstantsUnSplash.accessKey),
            URLQueryItem(name: OAuth2Service.clientSecretString, value: ConstantsUnSplash.secretKey),
            URLQueryItem(name: OAuth2Service.redirectUriString, value: ConstantsUnSplash.redirectURI),
            URLQueryItem(name: OAuth2Service.codeString, value: code),
            URLQueryItem(name: OAuth2Service.grantTypeString, value: OAuth2Service.authorizationCodeString)
        ]
        let url = urlComponents.url!
        
        return URLRequest.makeHTTPRequestForToken(url: url, httpMethod: OAuth2Service.httpMethod)
    }
}


