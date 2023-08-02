//
//  TabBarViweController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 15.07.23.
//

import UIKit

final class TabBarViewController: UITabBarController {
    private struct Constanstants {
        static let tabBarImageList = "tab_editorial_active"
        static let tabBarImageProfile = "tab_profile_active"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        let appearance = UITabBarAppearance()
        UITabBar.appearance().standardAppearance = appearance
        appearance.backgroundColor = .ypBlack
        
        view.backgroundColor = .ypBlack
        let tabBar = UITabBar.self
        tabBar.appearance().tintColor = .ypWhite
        
        self.viewControllers = [
            generateVC(viewController: ImagesListViewController(),
                       title: nil,
                       image: UIImage(named: Constanstants.tabBarImageList)),
            generateVC(viewController: ProfileViewController(),
                       title: nil,
                       image: UIImage(named: Constanstants.tabBarImageProfile))]
    }
}

//MARK: - GenerateVC
private extension TabBarViewController {
    func generateVC(viewController: UIViewController, title: String?, image: UIImage?) -> UIViewController{
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        
        return viewController
    }
}

