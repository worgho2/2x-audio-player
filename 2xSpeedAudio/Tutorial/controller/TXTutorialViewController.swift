import UIKit

class TXTutorialViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    // MARK: - UIComponents
    private let pageControl: UIPageViewController = {
        let vc = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil
        )
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        vc.view.backgroundColor = .clear
        return vc
    }()
    
    // MARK: - Properties
    private let pagedViewControllers: [UIViewController] = {
        let url = Bundle.main.url(forResource: "demo", withExtension:"MP4")!
        
        return [
            TXTutorialStepViewController(
                url: url,
                title: "Compartilhe o áudio",
                description: "Dentro do seu aplicativo preferido, selecione seu áudio e busque pelo ícone de compartilhar <COLOCAR O ICONE AQUI>"
            ),
            TXTutorialStepViewController(
                url: url,
                title: "Select \"Listen with 2X\"",
                description: "Select this action to listen your audio with a variable speed. Don\'t worry, we won\'t access your audio"
            ),
            TXTutorialStepViewController(
                url: url,
                title: "End",
                description: "this is the last time this is happening"
            ),
        ]
    }()
    private var currentPage = 0
    
    // MARK: - ViewController Lifecycle methods
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        setupPageControl()
    }
    // MARK: - Setup methods
    private func setupPageControl() {
        pageControl.dataSource = self
        pageControl.delegate = self
        
        addChild(pageControl)
        view.addSubview(pageControl.view)
        
        pageControl.view.centerXAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.centerXAnchor
        ).isActive = true
        pageControl.view.centerYAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.centerYAnchor
        ).isActive = true
        pageControl.view.widthAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.widthAnchor,
            multiplier: 0.9
        ).isActive = true
        pageControl.view.heightAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.heightAnchor,
            multiplier: 0.9
        ).isActive = true
        
        let proxy = UIPageControl.appearance()
        
        proxy.pageIndicatorTintColor = .tertiaryLabel
        proxy.currentPageIndicatorTintColor = .secondaryLabel
        
        pageControl.didMove(toParent: self)
        pageControl.setViewControllers(
            [pagedViewControllers[0]],
            direction: .forward,
            animated: true,
            completion: nil
        )
    }
    
    // MARK: - UIPageViewControllerDelegate & DataSource methods
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = pagedViewControllers.firstIndex(of: viewController) else { return nil }
        
        if vcIndex <= 0 { return nil}
        return pagedViewControllers[vcIndex - 1]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = pagedViewControllers.firstIndex(of: viewController) else { return nil }
        
        if vcIndex >= pagedViewControllers.count - 1 { return nil}
        return pagedViewControllers[vcIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let vc = pageViewController.viewControllers?.first
        else { return }
        guard let index = pagedViewControllers.first { $0 == vc } as? TXTutorialStepViewController
        else { return }
        
        index.forcePlay()
        // TODO: Maybe pause/play video here?
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int { pagedViewControllers.count }
    func presentationIndex(for pageViewController: UIPageViewController) -> Int { currentPage }
}
