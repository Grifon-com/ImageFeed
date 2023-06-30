//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 22.06.23.
//

import UIKit

protocol AuthViewControllerDelegate {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
}
 
final class AuthViewController: UIViewController{
    let showWebSegueIdentifier = "ShowWebView"
    
    private var oAuth2Service: OAuth2ServiceProtocol?
    private var authToken: StorageTokenProtocol?
    
    var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oAuth2Service = OAuth2Service()
        authToken = OAuth2TokenStorage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showWebSegueIdentifier {
            guard let webViewViewController = segue.destination as? WebViewViewController else { fatalError("Failed to prepare for \(showWebSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

//MARK: - Delegate
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
}
