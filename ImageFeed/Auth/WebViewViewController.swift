//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 22.06.23.
//

import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

final class WebViewViewController: UIViewController {
    private static let responseTypeString = "response_type"
    private static let scopeString = "scope"
    
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    private var webView: WKWebView = {
        let webView = WKWebView()
        
        return webView
    }()
    
    private var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .ypBlack
        
        return progressView
    }()
    
    private var backButton: UIButton = {
        let backButton = UIButton()
        let image = UIImage(named: "nav_back_button")
        backButton.setImage(image, for: .normal)
        
        return backButton
    }()
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        backButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        setupUIElement()
        applyConstraint()
        
        webView.navigationDelegate = self
        setupURL()
        
        estimatedProgressObservation = webView.observe(\.estimatedProgress, options: []) { [weak self] _, _ in
            guard let self = self else { return }
            self.updateProgress()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    @objc private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

//MARK: - SetupURL
extension WebViewViewController {
    private func setupURL() {
        
        guard var urlComponents = URLComponents(string: ConstantsUnSplash.unSplashAuthorizeURLString) else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: ConstantsUnSplash.clientIdString, value: ConstantsUnSplash.accessKey),
            URLQueryItem(name: ConstantsUnSplash.redirectUriString, value: ConstantsUnSplash.redirectURI),
            URLQueryItem(name: WebViewViewController.responseTypeString, value: ConstantsUnSplash.code),
            URLQueryItem(name: WebViewViewController.scopeString, value: ConstantsUnSplash.accessScope)
        ]
        
        guard let url = urlComponents.url else { return }
        
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

//MARK: - WKNavigationDelegate
extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            decisionHandler(.cancel)
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == ConstantsUnSplash.authNativePath,
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == ConstantsUnSplash.code}) {
            
            return codeItem.value
        } else {
            return nil
        }
    }
}

//MARK: - KVO
private extension WebViewViewController {
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1) <= 0.0001
    }
}

//MARK: - Setup UIElement
private extension WebViewViewController {
    private func setupUIElement() {
        [webView, progressView, backButton].forEach {
            view.addSubview($0)
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    private func applyConstraint() {
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            progressView.leftAnchor.constraint(equalTo: view.leftAnchor),
            progressView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.widthAnchor.constraint(equalToConstant: 44)
        ])
    }
}
