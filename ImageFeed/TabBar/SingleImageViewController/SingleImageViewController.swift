//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 9.06.23.
//

import UIKit

final class SingleImageViewController: UIViewController {
    private struct Constants {
        static let imageBackButton = "Backward"
        static let imageSharedButton = "Sharing 1"
        static let backButtonIdentifier = "backButton"
        static let alertMessage = "Не удалось войти в систему"
        static let titleActionDismiss = "Не надо"
        static let titleActionRestart = "Повторить"
    }
    
    var image: UIImage?
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.maximumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private lazy var backButton: UIButton = {
        let backButton = UIButton()
        backButton.accessibilityIdentifier = Constants.backButtonIdentifier
        let image = UIImage(named: Constants.imageBackButton)
        backButton.setImage(image, for: .normal)
        backButton.addTarget(nil, action: #selector(didTapBackButton), for: .allTouchEvents)
        
        return backButton
    }()
    
    private lazy var sharedButton: UIButton = {
        let sharedButton = UIButton()
        let image = UIImage(named: Constants.imageSharedButton)
        sharedButton.setImage(image, for: .normal)
        sharedButton.addTarget(self, action: #selector(didTapSharedButton), for: .allTouchEvents)
        
        return sharedButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIElement()
        applyConstraint()
        
        scrollView.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapSharedButton(_ sender: UIButton) {
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

extension SingleImageViewController {
    //MARK: Rescale
    func rescaleAndCenterImageInScrollView(image: UIImage) {
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
    
    
    //MARK: King Fisher
    public func kingFisher(url: URL) {
        imageView.kf.setImage(with: url) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let imageResult):
                self.image = imageResult.image
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                self.showAlertDissmisOrRestart(url: url)
            }
        }
    }
}

private extension SingleImageViewController {
    //MARK: Show Error
    func showAlertDissmisOrRestart(url: URL) {
        let alertVc = UIAlertController(title: nil,
                                        message: Constants.alertMessage,
                                        preferredStyle: .alert)
        let actionDismiss = UIAlertAction(title: Constants.titleActionDismiss, style: .default) { _ in
            alertVc.dismiss(animated: true)
        }
        let actionRestart = UIAlertAction(title: Constants.titleActionRestart, style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.kingFisher(url: url)
        }
        alertVc.addAction(actionDismiss)
        alertVc.addAction(actionRestart)
        
        present(alertVc, animated: true)
    }
    
    //MARK: SetupUIElement
    func setupUIElement() {
        scrollView.addSubview(imageView)
        view.backgroundColor = .ypBlack
        
        view.addSubview(scrollView)
        view.addSubview(backButton)
        view.addSubview(sharedButton)
        
        [scrollView, imageView, backButton, sharedButton].forEach {
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func applyConstraint() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            imageView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.widthAnchor.constraint(equalToConstant: 44),
            
            sharedButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -51),
            sharedButton.heightAnchor.constraint(equalToConstant: 50),
            sharedButton.widthAnchor.constraint(equalToConstant: 50),
            sharedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
