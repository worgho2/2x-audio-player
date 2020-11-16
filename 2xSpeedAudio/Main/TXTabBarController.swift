import UIKit

final class TXTabBarController: UITabBarController {
    
    // MARK: - Inner types
    struct TabBarItem {
        let title: String
        let image: UIImage
        let viewController: UIViewController
    }
    
    // MARK: - Initalization
    init() {
        super.init(nibName: nil, bundle: nil)
        let url = Bundle.main.url(forResource: "demo", withExtension:"MP4")!
        initTabBar(with: [
            .init(
                title: "Home",
                image:UIImage(systemName: "house.fill")!,
                viewController: TXTutorialViewController(
                        url: url,
                        title: "Start",
                        description: "this is the fist time this is happening"
                ))
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
    
    // MARK: - Unused
    required init?(coder: NSCoder) {
        fatalError("This class is not supposed to be instantiated from the storyboard")
    }
}
