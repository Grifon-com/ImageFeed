//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Григорий Машук on 19.06.23.
//

import UIKit

class TabBarController: UITabBarController {
    //Индекс выбранной на данный момент вкладки хранится в свойстве selectedIndex,
    //а видимый в этот же момент контролле
    //в свойстве selectedViewController, соответственно.
    
   // Начиная с iOS 13.0 для конфигурирования UITabBar можно (и нужно) использовать класс UITabBarAppearance.
    private let appearance = UITabBarAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
}
