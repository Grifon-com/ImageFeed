//
//  ViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 25.05.23.
//

import UIKit

final class ImagesListViewController: UIViewController {
    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        applyConstraints()
        view.backgroundColor = .ypBlack
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.tableView.register(ImagesListCell.classForKeyedArchiver(), forCellReuseIdentifier: "ImagesListCell")
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

//MARK: - TableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO: REMOVE
        OAuth2TokenKeychainStorage().removeSuccessful()
        
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
        let indents = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
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
        let buttonImage = indexPath.row % 2 == 0 ? UIImage(named: "Active") : UIImage(named: "No Active")
        let textLabel = Date().dateTimeString
        let model = ImagesListCellModel(image: image, buttonImage: buttonImage, textLabel: textLabel)
        
        imageListCell.configure(model: model)
        
        return imageListCell
    }
}

private extension ImagesListViewController {
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12)
        ])
    }
}
