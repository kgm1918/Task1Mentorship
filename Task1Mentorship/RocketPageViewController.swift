//
//  RocketPageViewController.swift
//  Task1Mentorship
//
//  Created by Gulnaz Kaztayeva on 30.10.2025.
//

import UIKit

class RocketPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    private var rockets: [Rocket] = []
    private var pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        dataSource = self
        delegate = self

        setupPageControl()
        loadRockets()
    }

    private func setupPageControl() {
        pageControl.currentPageIndicatorTintColor = .white
        pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -12),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    private func loadRockets() {
        guard let url = URL(string: "https://api.spacexdata.com/v4/rockets") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("❌ Ошибка: \(error)")
                return
            }
            guard let data = data else { return }
            
            do {
                let rockets = try JSONDecoder().decode([Rocket].self, from: data)
                DispatchQueue.main.async {
                    self.rockets = rockets
                    self.pageControl.numberOfPages = rockets.count
                    if let first = rockets.first {
                        let vc = RocketViewController()
                        vc.rocket = first
                        self.setViewControllers([vc], direction: .forward, animated: false)
                    }
                }
            } catch {
                print("❌ Ошибка декодирования: \(error)")
            }
        }.resume()
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? RocketViewController,
              let index = rockets.firstIndex(where: { $0.id == currentVC.rocket?.id }),
              index > 0 else { return nil }

        let prevVC = RocketViewController()
        prevVC.rocket = rockets[index - 1]
        return prevVC
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentVC = viewController as? RocketViewController,
              let index = rockets.firstIndex(where: { $0.id == currentVC.rocket?.id }),
              index < rockets.count - 1 else { return nil }

        let nextVC = RocketViewController()
        nextVC.rocket = rockets[index + 1]
        return nextVC
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentVC = viewControllers?.first as? RocketViewController,
           let index = rockets.firstIndex(where: { $0.id == currentVC.rocket?.id }) {
            pageControl.currentPage = index
        }
    }
}


