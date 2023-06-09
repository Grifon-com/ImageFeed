//
//  ViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 25.05.23.
//

import UIKit


class ImagesListViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
    }
}

extension ImagesListViewController {
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let image = UIImage(named: photosName[indexPath.row]) else { return }
        
        cell.cellImage.image = image
        cell.cellLable.text = dateFormatter.string(from: Date())
        
        let imageButtonLike = UIImage(named: "Active")
        let imageButtonNoLike = UIImage(named: "No Active")
        
        let likeImage = indexPath.row % 2 != 0 ? imageButtonNoLike : imageButtonLike
        cell.cellButton.setImage(likeImage, for: .normal)
    }
}

//MARK: - TableViewDlegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        let indents = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let weithImageView = tableView.bounds.width - indents.left - indents.right
        let widthImage = image.size.width
        let coefficient = weithImageView / widthImage
        let heigtImageView = image.size.height * coefficient + indents.top + indents.bottom
        
        return heigtImageView
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
        self.configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
}

