//
//  AuthNavigationController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 2.07.23.
//

import Foundation
import UIKit

final class AuthNavigationController: UINavigationController {
    override var childForStatusBarStyle: UIViewController? {
        return visibleViewController
    }
}
