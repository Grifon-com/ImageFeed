//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 9.06.23.
//

import Foundation
import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
         super.viewDidLoad()
         imageView.image = image
    }
    
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    
}