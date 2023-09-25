//
//  ViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 25.05.23.
//

import UIKit
import Kingfisher

protocol ImagesListViewControllerProtocol: AnyObject {
    var presenter: ImagesListPresenterProtocol? { get set }
    func updateTableViewAnimated()
}

final class ImagesListViewController: UIViewController & ImagesListViewControllerProtocol {
    var presenter: ImagesListPresenterProtocol?
    
    private var flagForHud = true
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        guard let cellReuseIdentifier = presenter?.imagesListConfiguration?.cellReuseIdentifier,
              let contentInset = presenter?.imagesListConfiguration?.tableViewContentInsets
        else { return tableView }
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tableView.contentInset = contentInset
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let presenter else { return }
        setupUIElement()
        applyConstraints()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        presenter.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if flagForHud {
            UIBlockingProgressHUD.show()
            flagForHud = false
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

//MARK: - TableViewDelegate
extension ImagesListViewController: UITableViewDelegate {
    //срабатывает при тапе на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presenter else { return }
        let singleVc = SingleImageViewController()
        singleVc.modalPresentationStyle = .fullScreen
        var largeURL: URL?
        do {
            let url = try presenter.setupLargeURLImage(indexPath: indexPath, photos: presenter.photos)
            largeURL = url
        }
        catch {
            assertionFailure("\(error.localizedDescription)")
        }
        guard let largeURL else { return }
        UIBlockingProgressHUD.show()
        singleVc.kingFisher(url: largeURL)
        present(singleVc, animated: true)
    }
    
    //  вызывается прямо перед тем, как ячейка таблицы будет показана на экране
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter else { return }
        if indexPath.row + 1 == presenter.imagesListService?.photos.count {
            presenter.fetchPhotosNextPage()
        }
    }
    
    //высчитываем высоту ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let presenter else { return 100 }
        let imageSize = presenter.photos[indexPath.row].size
        let imageCellHeight = presenter.cellHeightCalculation(imageSize: imageSize, tableView: tableView)
        
        return imageCellHeight
    }
}

//MARK: - TAbleViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter else { return 0 }
        return presenter.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let presenter,
              let imageListCell = presenter.setupCell(tableView: tableView, indexPath: indexPath) as? ImagesListCell
        else { return UITableViewCell() }
        imageListCell.delegate = self
        var thumbURL: URL?
        do {
            let url = try presenter.setupThumbImageURL(indexPath: indexPath, photos: presenter.photos)
            thumbURL = url
        }
        catch {
            assertionFailure("\(error.localizedDescription)")
        }
        let placeholder = UIImage(named: Placeholder)
        let processor = RoundCornerImageProcessor(cornerRadius: CellImageCornerRadius)
        imageListCell.cellImageView.kf.indicatorType = .activity
        imageListCell.cellImageView.kf.setImage(with: thumbURL,
                                                placeholder: placeholder,
                                                options: [.processor(processor)]) { _ in
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        return imageListCell
    }
}

extension ImagesListViewController: ImageListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard var presenter,
              let indexPath = tableView.indexPath(for: cell)
        else { return }
        presenter.imageListCellDidTapLike(cell: cell, tableView: tableView) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                guard let photosPresenter = presenter.imagesListService?.photos else { return }
                presenter.photos = photosPresenter
                // Изменим индикатор лайка картинки
                cell.setIsLiked(isLike: presenter.photos[indexPath.row].isLiked)
            case .failure(let error):
                assertionFailure("\(error.localizedDescription)")
                let alert = UIAlertController(title: ConstantsImageFeed.alertTitle, message: ConstantsImageFeed.alertMessage, preferredStyle: .alert)
                let action = UIAlertAction(title: ConstantsImageFeed.alertActionTitle, style: .default) { _ in
                    alert.dismiss(animated: true)
                }
                alert.addAction(action)
                present(alert, animated: true)
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}

extension ImagesListViewController {
    //MARK: Update Table View Animated
    func updateTableViewAnimated() {
        guard let presenter else { return }
        presenter.setupListIndexPath(tableView: tableView) { [weak self] result in
            guard let self else { return }
            switch result {
            case let(listIndexPath):
                self.tableView.insertRows(at: listIndexPath, with: .automatic)
            }
        }
    }
    
    //MARK: SetupUIElement
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



