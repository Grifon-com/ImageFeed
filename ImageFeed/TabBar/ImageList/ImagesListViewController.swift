//
//  ViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 25.05.23.
//

import UIKit

final class ImagesListViewController: UIViewController {
    private static let cellReuseIdentifier = "ImagesListCell"
    private static let imageLikeName = "Active"
    private static let imageNoLikeName = "No Active"
    private static let edgeInsetsTableView = (top: 12, left: 0, bottom: 12, right: 0)
    private static let edgeInsetsCellView = (top: 4, left: 16, bottom: 4, right: 16)
    
    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ImagesListCell.classForKeyedArchiver(), forCellReuseIdentifier: ImagesListViewController.cellReuseIdentifier)
        tableView.contentInset = UIEdgeInsets(top: CGFloat(ImagesListViewController.edgeInsetsTableView.top),
                                              left: CGFloat(ImagesListViewController.edgeInsetsTableView.left),
                                              bottom: CGFloat(ImagesListViewController.edgeInsetsTableView.bottom),
                                              right: CGFloat(ImagesListViewController.edgeInsetsTableView.right))
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIElement()
        applyConstraints()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

//MARK: - TableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleVc = SingleImageViewController()
        singleVc.modalTransitionStyle = .crossDissolve
        singleVc.modalPresentationStyle = .fullScreen
        let image = UIImage(named: photosName[indexPath.row])
        singleVc.image = image
        present(singleVc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let indents = UIEdgeInsets(top: CGFloat(ImagesListViewController.edgeInsetsCellView.top),
                                   left: CGFloat(ImagesListViewController.edgeInsetsCellView.left),
                                   bottom: CGFloat(ImagesListViewController.edgeInsetsCellView.bottom),
                                   right: CGFloat(ImagesListViewController.edgeInsetsCellView.right))
        let widthImageView = tableView.bounds.width - indents.left - indents.right
        let widthImage = image.size.width
        let coefficient = widthImageView / widthImage
        let heightImageView = image.size.height * coefficient + indents.top + indents.bottom
        
        return heightImageView
    }
}

//MARK: - TAbleViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        guard let image = UIImage(named: photosName[indexPath.row]) else { return UITableViewCell() }
        let buttonImage = indexPath.row % 2 == 0 ? UIImage(named: ImagesListViewController.imageLikeName) : UIImage(named: ImagesListViewController.imageNoLikeName)
        let textLabel = Date().dateTimeString
        let model = ImagesListCellModel(image: image, buttonImage: buttonImage, textLabel: textLabel)
        
        imageListCell.configure(model: model)
        
        return imageListCell
    }
}

//MARK: - SetupUielement
private extension ImagesListViewController {
    func setupUIElement() {
        view.backgroundColor = .ypBlack
        view.addSubview(tableView)
    }
    
    func applyConstraints() {
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12)
        ])
    }
}
