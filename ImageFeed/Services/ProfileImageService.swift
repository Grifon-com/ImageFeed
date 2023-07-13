//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Григорий Машук on 10.07.23.
//

import Foundation
protocol ProfileImageServiceProtocol {
    func fetchProfileImageUrl(username: String, completion: @escaping (Result<String, Error>) -> Void)
}

final class ProfileImageService: ProfileImageServiceProtocol {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileimageproviderDidChange")
    private static let path = "/users/username"
    
    private let profileService = ProfileService.shared
    private let oAuth2TokenStorage = OAuth2TokenStorage.shared
    private let urlSession = URLSession.shared
    
    private (set) var avatarURL: String?
    private var lastToken: String?
    private var task: URLSessionTask?
   
    func fetchProfileImageUrl(username: String, completion: @escaping (Result <String, Error>) -> Void) {
        assert(Thread.isMainThread)
        guard let token = oAuth2TokenStorage.token else { return }
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        let request = profileImageRequest(token: token, username: username)
        let task = urlSession.objectTask(for: request) { [weak self] (result: Result<UserResult, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let profileImageURL):
                guard let profileImageURL = profileImageURL.profileImage.small else { return }
                self.avatarURL = profileImageURL
                completion(.success(profileImageURL))
                NotificationCenter.default.post(name: ProfileImageService.didChangeNotification, object: self, userInfo: ["URL": profileImageURL])
            case .failure(let error):
                completion(.failure(error))
                self.lastToken = nil
            }
        }
        task.resume()
    }
}

//MARK: - Request
private extension ProfileImageService {
    private func profileImageRequest(token: String, username: String) -> URLRequest {
        let bearerToken = "\(ConstantsUnSplash.bearer) \(token)"
        let urlString =  "\(ConstantsUnSplash.jsondefaultBaseURL.absoluteString)\(ProfileImageService.path)"
        let url = URL(string: urlString)!
        print(urlString)
        return URLRequest.makeHTTPRequestForModel(url: url, bearerToken: bearerToken, forHTTPHeaderField: ConstantsUnSplash.hTTPHeaderField)
    }
}

