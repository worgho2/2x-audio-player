//
//  TXTabBarController.swift
//  2xSpeedAudio
//
//  Created by bruno pastre on 02/12/20.
//

import UIKit
import Speech

final class MainTabBarController: UITabBarController {
    
    // MARK: - Inner types
    struct TabBarItem {
        let title: String
        let image: UIImage
        let viewController: UIViewController
    }
    
    // MARK: - Initalization
    override func viewDidLoad() {
        super.viewDidLoad()
        initTabBar(with: [
//            .init(
//                title: "Home",
//                image: UIImage(systemName: "house.fill")!,
//                viewController: UINavigationController(rootViewController: TXTutorialViewController())
//            ),
            .init(
                title: "Settings",
                image: UIImage(systemName: "gear")!,
                viewController: UIStoryboard(name: "Settings", bundle: nil).instantiateInitialViewController()!
            )
        ])
    }
    
    private func initTabBar(with items: [TabBarItem]) {
        items.forEach { item in
            let vc = item.viewController
            vc.tabBarItem = UITabBarItem(
                title: item.title,
                image: item.image,
                selectedImage: item.image
            )
        }
        viewControllers = items.map { $0.viewController }
    }
    
}
