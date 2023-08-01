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
    static let shared = OAuth2Service()
    
    private static let httpMethod = "POST"
    private static let clientSecretString = "client_secret"
    private static let codeString = "code"
    private static let grantTypeString = "grant_type"
    private static let authorizationCodeString = "authorization_code"
    
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private let authToken = OAuth2TokenKeychainStorage()
    
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
                do { try self.authToken.storageToken(newToken: authToken)
                } catch {
                    let errorStorage = KeychainError.errorStorageToken
                    completion(.failure(errorStorage))
                }
                completion(.success(authToken))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.lastCode = nil
            }
        }
        self.task = task
        task.resume()
    }
}

private extension OAuth2Service {
    private func authTokenRequest(code: String) throws -> URLRequest {
        let urlAbsoluteString = "\(ConstantsUnSplash.defaultBaseURL)\(ConstantsUnSplash.pathToken)"
        guard var urlComponents = URLComponents(string: urlAbsoluteString) else {
            throw NetworkError.urlComponentsError
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: ConstantsUnSplash.clientIdString, value: ConstantsUnSplash.accessKey),
            URLQueryItem(name: OAuth2Service.clientSecretString, value: ConstantsUnSplash.secretKey),
            URLQueryItem(name: ConstantsUnSplash.redirectUriString, value: ConstantsUnSplash.redirectURI),
            URLQueryItem(name: OAuth2Service.codeString, value: code),
            URLQueryItem(name: OAuth2Service.grantTypeString, value: OAuth2Service.authorizationCodeString)
        ]
        guard let url = urlComponents.url else { throw NetworkError.urlError}
        return URLRequest.makeHTTPRequest(url: url, httpMethod: OAuth2Service.httpMethod)
    }
}


