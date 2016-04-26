//
//  WelcomePageViewController.swift
//  MealTracker_Welcome_Pages
//
//  Created by Valti Skobo on 3/31/16.
//  Copyright © 2016 Valti Skobo. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIPageViewController {
    
    weak var welcomeDelegate: WelcomePageViewControllerDelegate?
    
    private(set) lazy var orderedViewControllers: [UIViewController] = {
        return [self.newWelcomeSlideViewController("WelcomeSlide0"),
            self.newWelcomeSlideViewController("WelcomeSlide1")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let firstViewController = orderedViewControllers.first {
            setViewControllers([firstViewController],
                direction: .Forward,
                animated: true,
                completion: nil)
        }
        
        welcomeDelegate?.welcomePageViewController(self, didUpdatePageCount: orderedViewControllers.count)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    
    private func newWelcomeSlideViewController(slide: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewControllerWithIdentifier("\(slide)ViewController")
    }
}


extension WelcomePageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
                return nil
            }
            
            let previousIndex = viewControllerIndex - 1
            
            guard previousIndex >= 0 else {
                return nil
            }
            
            guard orderedViewControllers.count > previousIndex else {
                return nil
            }
            
            return orderedViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderedViewControllers.indexOf(viewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            let orderedViewControllersCount = orderedViewControllers.count
            
            guard orderedViewControllersCount != nextIndex else {
                return nil
            }
            
            guard orderedViewControllersCount > nextIndex else {
                return nil
            }
            
            return orderedViewControllers[nextIndex]
    }
    
}

extension WelcomePageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
            if let firstViewController = viewControllers?.first,
                let index = orderedViewControllers.indexOf(firstViewController) {
                    welcomeDelegate?.welcomePageViewController(self,
                        didUpdatePageIndex: index)
            }
    }
    
}

protocol WelcomePageViewControllerDelegate: class {
    
    func welcomePageViewController(welcomePageViewController: WelcomePageViewController,
        didUpdatePageCount count: Int)
    
    func welcomePageViewController(welcomePageViewController: WelcomePageViewController,
        didUpdatePageIndex index: Int)
    
}







