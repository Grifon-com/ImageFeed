//
//  Profile.swift
//  ImageFeed
//
//  Created by Григорий Машук on 7.07.23.
//

import Foundation

protocol ProfileServiceProtocol {
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void)
}

final class ProfileService: ProfileServiceProtocol {
    private static let at = "@"
    private static let path = "/me"
    private static let emptyLine = ""
    
    static let shared = ProfileService()

    private let urlSession = URLSession.shared
    
    private var lastToken: String?
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        var request: URLRequest?
        do { let modelRequest = try profileModelRequest(token: token)
            request = modelRequest
        }
        catch {
            let errorRequest = NetworkError.urlComponentsError
            completion(.failure(errorRequest))
        }
        guard let request = request else { return }
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.profile = convertModel(model: model)
                completion(.success(model))
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
            }
            self.lastToken = nil
        }
        task.resume()
    }
}
//MARK: - Request
private extension ProfileService {
    private func profileModelRequest(token: String) throws -> URLRequest {
        let bearerToken = "\(ConstantsUnSplash.bearer) \(token)"
        let urlAbsoluteString = "\(ConstantsUnSplash.jsonDefaultBaseURL)\(ProfileService.path)"
        guard let url = URL(string: urlAbsoluteString) else { throw NetworkError.urlError }
        
        let request = URLRequest.makeHTTPRequestForModel(url: url,
                                                         bearerToken: bearerToken,
                                                         forHTTPHeaderField: ConstantsUnSplash.hTTPHeaderField)
        return request
    }
}

//MARK: - Convert Model
private extension ProfileService {
    private func convertModel(model: ProfileResult) -> Profile {
        let username = model.username ?? ProfileService.emptyLine
        let firstName = model.firstName ?? ProfileService.emptyLine
        let lastName = model.lastName ?? ProfileService.emptyLine
        let loginName = "\(ProfileService.at)\(username)"
        let bio = model.bio ?? ProfileService.emptyLine
        let name = "\(firstName)\(lastName)"
        
        let profile = Profile(username: username,
                              name: name,
                              loginName: loginName, bio: bio)
        return profile
    }
}
