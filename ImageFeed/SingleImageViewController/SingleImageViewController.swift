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
            rescaleAndCenterImageInScrollView(image: image)
        }
    }
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        
        scrollView.maximumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        rescaleAndCenterImageInScrollView(image: image)
    }
    
    @IBAction private func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let image = image else { return }
        let content: [Any] = [image]
        
        let sharing = UIActivityViewController(activityItems: content, applicationActivities: nil)
        
        present(sharing, animated: true)
    }
}

//MARK: - UIScrollViewDelegate
extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

//MARK: - Rescale
extension SingleImageViewController {
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}
