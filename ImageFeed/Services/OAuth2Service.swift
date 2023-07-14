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
    private static let clientSecretString = "client_secret"
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
        let request = try? authTokenRequest(code: code)
        guard let request = request else { return }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<OAuthTokenResponseBody, Error>) in
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
    private func authTokenRequest(code: String) throws -> URLRequest {
        let urlAbsoluteString = ConstantsUnSplash.defaultBaseURL + ConstantsUnSplash.path
        guard var urlComponents = URLComponents(string: urlAbsoluteString) else {
            throw NetworkError.urlComponents
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: ConstantsUnSplash.clientIdString, value: ConstantsUnSplash.accessKey),
            URLQueryItem(name: OAuth2Service.clientSecretString, value: ConstantsUnSplash.secretKey),
            URLQueryItem(name: ConstantsUnSplash.redirectUriString, value: ConstantsUnSplash.redirectURI),
            URLQueryItem(name: OAuth2Service.codeString, value: code),
            URLQueryItem(name: OAuth2Service.grantTypeString, value: OAuth2Service.authorizationCodeString)
        ]
        guard let url = urlComponents.url else { throw NetworkError.urlError}
        
        return URLRequest.makeHTTPRequestForToken(url: url, httpMethod: OAuth2Service.httpMethod)
    }
}


