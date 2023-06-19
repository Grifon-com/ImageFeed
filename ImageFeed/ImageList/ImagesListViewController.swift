//
//  ViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 25.05.23.
//

import UIKit


final class ImagesListViewController: UIViewController {
    
    private let photosName: [String] = Array(0..<20).map{"\($0)"}
    
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    @IBOutlet private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard let viewController = segue.destination as? SingleImageViewController,
                  let indexPath = sender as? IndexPath else { return }
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}


//MARK: - TableViewDlegate
extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
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
        
        guard let image = UIImage(named: photosName[indexPath.row]) else { return UITableViewCell() }
        let buttonImage = indexPath.row % 2 == 0 ? UIImage(named: "Active") : UIImage(named: "No Active")
        let textLable = Date().dateTimeString
        let model = ImagesListCellModel(image: image, buttonImage: buttonImage, textLabel: textLable)
        
        imageListCell.configure(model: model)
        
        return imageListCell
    }
}
