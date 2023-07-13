//
//  ProfileServise.swift
//  ImageFeed
//
//  Created by Григорий Машук on 7.07.23.
//

import Foundation

protocol ProfileServiseProtocol {
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void)
}

final class ProfileService: ProfileServiseProtocol {
    static let shared = ProfileService()
    
    private static let at = "@"
    private static let path = "/me"
    
    private let urlSession = URLSession.shared
    
    private var lastToken: String?
    private var task: URLSessionTask?
    private(set) var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<ProfileResult, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        let request = profileModelRequest(token: token)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                profile = convertModel(model: model)
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
    private func profileModelRequest(token: String) -> URLRequest {
        let bearerToken = "\(ConstantsUnSplash.bearer) \(token)"
        let urlAbsoluteString = "\(ConstantsUnSplash.jsondefaultBaseURL.absoluteString)\(ProfileService.path)"
        let url = URL(string: urlAbsoluteString)!
        
        let request = URLRequest.makeHTTPRequestForModel(url: url,
                                                         bearerToken: bearerToken,
                                                         forHTTPHeaderField: ConstantsUnSplash.hTTPHeaderField)
        return request
    }
}

//MARK: - Convert Model
private extension ProfileService {
    private func convertModel(model: ProfileResult) -> Profile {
        let username = model.username ?? ""
        let firstName = model.firstName ?? ""
        let lastName = model.lastName ?? ""
        let loginName = "\(ProfileService.at)\(username)"
        let bio = model.bio ?? ""
        let name = "\(firstName)\(lastName)"
        
        let profile = Profile(username: username,
                              name: name,
                              loginName: loginName, bio: bio)
        return profile
    }
}
