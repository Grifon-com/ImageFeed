//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Григорий Машук on 24.06.23.
//

import Foundation

protocol OAuth2ServiceProtocol {
    func fetchAuthToken(_ code: String, complition: @escaping (Result <String, Error>) -> Void)
}

private enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
}

final class OAuth2Service: OAuth2ServiceProtocol {
    static let shared = OAuth2Service()
    
    private let urlSession = URLSession.shared
    private (set) var authToken: String? {
        get { return OAuth2TokenStorage().token}
        set { OAuth2TokenStorage().token = newValue }
    }
    
    func fetchAuthToken(_ code: String, complition: @escaping (Result <String, Error>) -> Void) {
        let request = authTokenRequest(code: code)
        let task = object(for: request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let body):
                let authToken = body.accessToken
                self.authToken = authToken
                complition(.success(authToken))
            case .failure(let error):
                complition(.failure(error))
            }
        }
        task.resume()
    }
}

extension OAuth2Service {
    private func object(for request: URLRequest, complition: @escaping (Result<OAuthTokenResponseBody, Error>) -> Void) -> URLSessionTask {
        let decoder = JSONDecoder()
        return urlSession.data(for: request) {(result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<OAuthTokenResponseBody, Error> in
                Result { try decoder.decode(OAuthTokenResponseBody.self, from: data) }
            }
            complition(response)
        }
    }
    
    private struct OAuthTokenResponseBody: Decodable {
        let accessToken: String
        let tokenType: String
        let scope: String
        let createdAt: Int
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case scope
            case createdAt = "created_at"
        }
    }
    
    private func authTokenRequest(code: String) -> URLRequest {
        let urlObsoluteString = DefaultBaseURL.absoluteString + Path
        guard var urlComponents = URLComponents(string: urlObsoluteString ) else { fatalError("URL error") }
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: AccessKey),
            URLQueryItem(name: "client_secret", value: SecretKey),
            URLQueryItem(name: "redirect_uri", value: RedirectURI),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        guard let url = urlComponents.url else { fatalError("URL generation error") }
        
        return URLRequest.makeHTTPRequest(url: url, httpMethod: "POST")
    }
}

extension URLSession {
    func data(for request: URLRequest, complition: @escaping (Result <Data, Error>) -> Void) -> URLSessionTask {
        let fullfillComplition: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                complition(result)
            }
        }
        let task = dataTask(with: request, completionHandler: {data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= statusCode {
                    fullfillComplition(.success(data))
                } else {
                    fullfillComplition(.failure(NetworkError.httpStatusCode(statusCode)))
                    print(statusCode)
                }
            } else if let error = error {
                fullfillComplition(.failure(NetworkError.urlRequestError(error)))
            } else {
                fullfillComplition(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
}

extension URLRequest {
    static func makeHTTPRequest(url: URL, httpMethod: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        return request
    }
}
