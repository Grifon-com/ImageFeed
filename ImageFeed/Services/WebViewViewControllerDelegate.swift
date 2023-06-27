//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Григорий Машук on 23.06.23.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
