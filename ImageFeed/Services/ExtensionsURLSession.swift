//
//  ExtensionsURLSession.swift
//  ImageFeed
//
//  Created by Григорий Машук on 10.07.23.
//

import Foundation

extension URLSession {
    func data(for request: URLRequest, completion: @escaping (Result <Data, Error>) -> Void) -> URLSessionTask {
        let fulfillCompletion: (Result<Data, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: {data, response, error in
            if let data = data,
               let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= statusCode {
                    fulfillCompletion(.success(data))
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
    
    func statusCode(for request: URLRequest, completion: @escaping (Result <Void, Error>) -> Void) -> URLSessionTask {
        let fulfillCompletion: (Result<Void, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        let task = dataTask(with: request, completionHandler: {_, response, error in
            if let response = response,
               let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200..<300 ~= statusCode {
                    completion(.success(Void()))
                } else {
                    fulfillCompletion(.failure(NetworkError.httpStatusCode(statusCode)))
                }
            } else if let error = error {
                fulfillCompletion(.failure(NetworkError.urlRequestError(error)))
            } else {
                fulfillCompletion(.failure(NetworkError.urlSessionError))
            }
        })
        task.resume()
        return task
    }
    
    func objectTask<T: Codable>(for request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) -> URLSessionTask {
        let decoder = SnakeCaseJsonDecoder()
        return self.data(for: request) {(result: Result<Data, Error>) in
            let response = result.flatMap { data -> Result<T, Error> in
                Result { try decoder.decode(T.self, from: data) }
            }
            completion(response)
        }
    }
}
