//
//  PageVC.swift
//  PBL6
//
//  Created by KietKoy on 30/09/2023.
//

import UIKit

class PageVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    lazy var pages: [UIViewController] = [
        HomeVC(),
        EventVC(),
        AnalysisVC(),
        ProofVC(),
        AccountVC()
    ]
    
    private var currentPageIndex = -1
    
    func handleUIChangePage(pageIndex: Int) {
        
        if pageIndex == currentPageIndex { return }
        
        var direction = NavigationDirection.forward
        if pageIndex < currentPageIndex {
            direction = .reverse
        }
        
        setViewControllers(
            [pages[pageIndex]],
            direction: direction,
            animated: false)
        
        currentPageIndex = pageIndex
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        
        // ~= check if value range
        guard pages.indices ~= previousIndex else { return nil }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        
        guard pages.indices ~= nextIndex else { return nil }
        
        return pages[nextIndex]
    }
}

