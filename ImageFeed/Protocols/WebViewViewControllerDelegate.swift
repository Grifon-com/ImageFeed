//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Марина Машук on 23.06.23.
//

import Foundation

protocol WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
