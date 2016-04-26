//
//  SnapChatPageViewController.swift
//  MealTracker_Welcome_Pages
//  Created by Valti Skobo on 3/31/16.
//  Copyright © 2016 Valti Skobo. All rights reserved.
//

import UIKit

class SnapChatPageViewController: UIPageViewController {
    
    weak var snapDelegate: SnapChatPageViewControllerDelegate?
    
    private(set) lazy var orderingViewControllers: [UIViewController] = {
        return [ self.newWelcomeSlideViewController("vcSettings"),
            self.newWelcomeSlideViewController("vcHistory"),
            self.newWelcomeSlideViewController("vcHome"),
            self.newWelcomeSlideViewController("vcTagDetail"),
            self.newWelcomeSlideViewController("vcFoodPhilosophy")]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        let home = orderingViewControllers[2]
        setViewControllers([home],
            direction: .Forward,
            animated: true,
            completion: nil)
        
        snapDelegate?.snapchatPageViewController(self, didUpdatePageCount: orderingViewControllers.count)
    }
    
    func goSettings(direction: Bool){
        let home = orderingViewControllers[0]
        if direction == true{
            setViewControllers([home],
                direction: .Forward,
                animated: true,
                completion: nil)
        }else{
            setViewControllers([home],
                direction: .Reverse,
                animated: true,
                completion: nil)
        }
    }
    
    func goHistory(direction: Bool){
        let home = orderingViewControllers[1]
        if direction == true{
            setViewControllers([home],
                direction: .Forward,
                animated: true,
                completion: nil)
        }else{
            setViewControllers([home],
                direction: .Reverse,
                animated: true,
                completion: nil)
        }
    }
    
    func goHome(direction: Bool){
        let home = orderingViewControllers[2]
        if direction == true{
            setViewControllers([home],
                direction: .Forward,
                animated: true,
                completion: nil)
        }else{
            setViewControllers([home],
                direction: .Reverse,
                animated: true,
                completion: nil)
        }
    }
    
    func goDetail(direction: Bool){
        let home = orderingViewControllers[3]
        if direction == true{
            setViewControllers([home],
                direction: .Forward,
                animated: true,
                completion: nil)
        }else{
            setViewControllers([home],
                direction: .Reverse,
                animated: true,
                completion: nil)
        }
    }
    
    func goPhilosophy(direction: Bool){
        let home = orderingViewControllers[4]
        if direction == true{
            setViewControllers([home],
                direction: .Forward,
                animated: true,
                completion: nil)
        }else{
            setViewControllers([home],
                direction: .Reverse,
                animated: true,
                completion: nil)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    
    private func newWelcomeSlideViewController(slide: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil) .
            instantiateViewControllerWithIdentifier("\(slide)ViewController")
    }
}


extension SnapChatPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderingViewControllers.indexOf(viewController) else {
                return nil
            }
            
            let previousIndex = viewControllerIndex - 1
            
            guard previousIndex >= 0 else {
                return nil
            }
            
            guard orderingViewControllers.count > previousIndex else {
                return nil
            }
            
            return orderingViewControllers[previousIndex]
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
            guard let viewControllerIndex = orderingViewControllers.indexOf(viewController) else {
                return nil
            }
            
            let nextIndex = viewControllerIndex + 1
            let orderingViewControllersCount = orderingViewControllers.count
            
            guard orderingViewControllersCount != nextIndex else {
                return nil
            }
            
            guard orderingViewControllersCount > nextIndex else {
                return nil
            }
            
            return orderingViewControllers[nextIndex]
    }
    
}

extension SnapChatPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool) {
            if let firstViewController = viewControllers?.first,
                let index = orderingViewControllers.indexOf(firstViewController) {
                    snapDelegate?.snapchatPageViewController(self,
                        didUpdatePageIndex: index)
            }
    }
    
}

protocol SnapChatPageViewControllerDelegate: class {
    
    func snapchatPageViewController(snapchatPageViewController: SnapChatPageViewController,
        didUpdatePageCount count: Int)
    
    func snapchatPageViewController(snapchatPageViewController: SnapChatPageViewController,
        didUpdatePageIndex index: Int)
    
}