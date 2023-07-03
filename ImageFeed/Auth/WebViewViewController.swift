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
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var progressView: UIProgressView!
    
    weak var delegate: WebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        setupURL()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    @IBAction private func didTapBackButton(_ sender: Any?) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

//MARK: - SetupURL
extension WebViewViewController {
    private func setupURL() {
        
        guard var urlComponents = URLComponents(string: ConstantsUnSplash.unSplashAuthorizeURLString) else { return }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: ConstantsUnSplash.accessKey),
            URLQueryItem(name: "redirect_uri", value: ConstantsUnSplash.redirectURI),
            URLQueryItem(name: "response_type", value: ConstantsUnSplash.code),
            URLQueryItem(name: "scope", value: ConstantsUnSplash.accessScope)
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
            //TODO: - process code
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
extension WebViewViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            updateProgress()
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1) <= 0.0001
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //подписываемся на обновления используя KVO
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,context: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //отписываемся от обновлений
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
}
