//
//  ViewController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 25.05.23.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    struct Constants {
        static let cellReuseIdentifier = "ImagesListCell"
        static let placeholder = "placeholderCell"
        static let tableViewContentInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        static let cellViewIndents = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        static let defaultSectionCount = 0
        static let cellImageCornerRadius: Double = 16
    }
    
    private let imagesListService = ImagesListService.shared
    private let dateFarmatter = FormatDate.shared
    private var imageListServiceObserver: NSObjectProtocol?
    private var photos: [Photo] = []
    private var flagForHud = true
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ImagesListCell.classForKeyedArchiver(), forCellReuseIdentifier: Constants.cellReuseIdentifier)
        tableView.contentInset = Constants.tableViewContentInsets
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIElement()
        applyConstraints()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        imagesListService.fetchPhotosNextPage()
        
        imageListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            self.updateTableViewAnimated()
        }
        self.updateTableViewAnimated()
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
        let singleVc = SingleImageViewController()
        singleVc.modalPresentationStyle = .fullScreen
        let urlImageString = photos[indexPath.row].largeImageURL
        var url: URL?
        do { let urlImage = try setupURL(urlString: urlImageString)
            url = urlImage
        }
        catch {
            let urlError = NetworkError.urlError
            print(urlError)
        }
        guard let url = url else { return }
        self.present(singleVc, animated: true)
        UIBlockingProgressHUD.show()
        singleVc.kingFisher(url: url)
    }
    
    //  вызывается прямо перед тем, как ячейка таблицы будет показана на экране
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row + 1 == imagesListService.photos.count { imagesListService.fetchPhotosNextPage()
        }
    }
    
    //высчитываем высоту ячейки
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageSize = photos[indexPath.row].size
        let imageCellHeight = cellHeightCalculation(imageSize: imageSize, tableView: tableView)
        
        return imageCellHeight
    }
}

//MARK: - TAbleViewDataSource
extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.Constants.reuseIdentifier, for: indexPath)
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        
        let urlString = photos[indexPath.row].thumbImageURL
        var urlForKf: URL?
        do { let url = try setupURL(urlString: urlString)
            urlForKf = url
        }
        catch {
            let errorUrl = NetworkError.urlError
            print("\(errorUrl)")
        }
        
        let placeholder = UIImage(named: Constants.placeholder)
        let processor = RoundCornerImageProcessor(cornerRadius: Constants.cellImageCornerRadius)
        imageListCell.cellImageView.kf.indicatorType = .activity
        imageListCell.cellImageView.kf.setImage(with: urlForKf,
                                                placeholder: placeholder,
                                                options: [.processor(processor)]) { [ weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        let model = setupImagesListCellModel(indexPath: indexPath)
        imageListCell.configure(model: model)
        
        return imageListCell
    }
    
}

private extension ImagesListViewController {
    //MARK: Update Table View Animated
    func updateTableViewAnimated() {
        tableView.performBatchUpdates {
            let startIndex = photos.count
            let endIndex = imagesListService.photos.count
            photos = imagesListService.photos
            if startIndex != endIndex {
                let listIndexPath = (startIndex..<endIndex).map {
                    IndexPath(row: $0, section: Constants.defaultSectionCount)
                }
                tableView.insertRows(at: listIndexPath, with: .automatic)
            }
        }
    }
    
    func setupImagesListCellModel(indexPath: IndexPath) -> ImagesListCellModel {
        let photo = photos[indexPath.row]
        
        let isLike = photo.isLiked
        let textLabel: String = dateFarmatter.setupUIDateString(date: photo.createdAt) ?? ConstantsImageFeed.emptyLine
        let buttonImage = isLike ? ConstantsImageFeed.imageLike: ConstantsImageFeed.imageNoLike
        let model = ImagesListCellModel(buttonImage: buttonImage, textLabel: textLabel)
        
        return model
    }
    
    //TODO: Cell Height Calculation
    func cellHeightCalculation(imageSize: CGSize, tableView: UITableView) -> CGFloat {
        let indents = Constants.cellViewIndents
        let widthImageView = tableView.bounds.width - indents.left - indents.right
        let widthImage = imageSize.width
        let coefficient = widthImageView / widthImage
        let heightImageView = imageSize.height * coefficient + indents.top + indents.bottom
        
        return heightImageView
    }
    
    //MARK: Setup URL
    func setupURL(urlString: String) throws -> URL? {
        guard let url = URL(string: urlString) else { throw NetworkError.urlError }
        return url
    }
    
    //MARK: SetupUielement
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

extension ImagesListViewController: ImageListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        UIBlockingProgressHUD.show()
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        imagesListService.chengeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self]  result in
            guard let self = self else { return }
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    //Синхрогизируем массив картинок с сервисом
                    self.photos = self.imagesListService.photos
                    // Изменим индикатор лайка картинки
                    cell.setIsLiked(isLike: self.photos[indexPath.row].isLiked)
                }
            case .failure(let error):
                print(error)
                let alert = UIAlertController(title: ConstantsImageFeed.alertTitle, message: ConstantsImageFeed.alertMessage, preferredStyle: .alert)
                let action = UIAlertAction(title: ConstantsImageFeed.alertActionTitle, style: .default)
                alert.addAction(action)
                present(alert, animated: true)
            }
            DispatchQueue.main.async {
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}

