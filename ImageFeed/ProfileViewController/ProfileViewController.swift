//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 8.06.23.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var loginNameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet var logoutButton: UIButton!
    
    @IBAction func didTapLogoutButton() {}
    
}
