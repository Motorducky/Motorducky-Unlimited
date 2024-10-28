import UIKit

class MainViewController: UIViewController {

    var pageViewController: UIPageViewController!
    var pages = [UIViewController]()
    var pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupPageViewController()
        setupPageControl()
    }

    private func setupPageViewController() {
        pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil)
        
        pageViewController.dataSource = self
        pageViewController.delegate = self // Add the delegate

        let initialPage = 0
        let firstPage = ViewController() // Your existing button view controller
        let secondPage = TextViewController()
        let thirdPage = ImageViewController()

        pages.append(firstPage)
        pages.append(secondPage)
        pages.append(thirdPage)

        pageViewController.setViewControllers([pages[initialPage]],
                                              direction: .forward,
                                              animated: true,
                                              completion: nil)

        pageViewController.view.frame = view.bounds
        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)
    }

    private func setupPageControl() {
        pageControl = UIPageControl(frame: .zero)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.tintColor = UIColor.systemBlue
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.systemBlue

        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension MainViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = currentIndex - 1
        guard previousIndex >= 0 else { return nil }
        return pages[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = currentIndex + 1
        guard nextIndex < pages.count else { return nil }
        return pages[nextIndex]
    }
}

// Implement the UIPageViewControllerDelegate to update the page control
extension MainViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentViewController = pageViewController.viewControllers?.first,
           let index = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = index
        }
    }
}
