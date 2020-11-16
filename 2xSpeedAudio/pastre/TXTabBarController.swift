import UIKit

final class TXTabBarController: UITabBarController {
    
    // MARK: - Initalization
    init() {
        super.init(nibName: nil, bundle: nil)
        let url = Bundle.main.url(forResource: "start", withExtension:"MP4")!
        viewControllers = [
            TXTutorialViewController(
                url: url,
                title: "Start",
                description: "this is the fist time this is happening"
            )
        ]
    }
    
    // MARK: - Unused
    required init?(coder: NSCoder) {
        fatalError("This class is not supposed to be instantiated from the storyboard")
    }
}
