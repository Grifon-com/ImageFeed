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
    private struct Constants {
        static let clientSecretString = "client_secret"
        static let grantTypeString = "grant_type"
        static let authorizationCodeString = "authorization_code"
    }
    
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private let configuration: AuthConfiguration
    private var task: URLSessionTask?
    private var lastCode: String?
    
    private let authToken = OAuth2TokenKeychainStorage()
    
    init(configuration: AuthConfiguration = .standard) {
        self.configuration = configuration
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
        let urlAbsoluteString = "\(configuration.defaultBaseURL)\(ConstantsImageFeed.pathToken)"
        guard var urlComponents = URLComponents(string: urlAbsoluteString) else {
            throw NetworkError.urlComponentsError
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: ConstantsImageFeed.clientIdString, value: configuration.accessKey),
            URLQueryItem(name: Constants.clientSecretString, value: configuration.secretKey),
            URLQueryItem(name: ConstantsImageFeed.redirectUriString, value: configuration.redirectURI),
            URLQueryItem(name: ConstantsImageFeed.code, value: code),
            URLQueryItem(name: Constants.grantTypeString, value: Constants.authorizationCodeString)
        ]
        guard let url = urlComponents.url else { throw NetworkError.urlError}
        return URLRequest.makeHTTPRequest(url: url, httpMethod: ConstantsImageFeed.postHTTPMethod)
    }
}


