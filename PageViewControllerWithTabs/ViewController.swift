//
//  ViewController.swift
//  PageViewControllerWithTabs
//
//  Created by Leela Prasad on 22/03/18.
//  Copyright © 2018 Leela Prasad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    
    
    @IBOutlet weak var menuBarView: MenuTabsView!
    
    var currentIndex: Int = 0 {
        
        didSet{
            
            
        }
        
    }
    
    var names = ["Menu TAB 1","Menu TAB 2","Menu TAB 3","Menu TAB 4","Menu TAB 5","Menu TAB 6"]
    
    var pageController: UIPageViewController!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBarView.dataArray = names
        menuBarView.isSizeToFitCellsNeeded = true
        menuBarView.collView.backgroundColor = UIColor.init(white: 0.97, alpha: 0.97)
        
        presentPageVCOnView()
        
        menuBarView.menuDelegate = self
        pageController.delegate = self
        pageController.dataSource = self
    
        
        //For Intial Display
        menuBarView.collView.selectItem(at: IndexPath.init(item: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
        pageController.setViewControllers([viewController(At: 0)!], direction: .forward, animated: true, completion: nil)

    }
    
    func presentPageVCOnView() {
        
        self.pageController = storyboard?.instantiateViewController(withIdentifier: "PageControllerVC") as! PageControllerVC
        self.pageController.view.frame = CGRect.init(x: 0, y: menuBarView.frame.maxY, width: self.view.frame.width, height: self.view.frame.height - menuBarView.frame.maxY)
        self.addChildViewController(self.pageController)
        self.view.addSubview(self.pageController.view)
        self.pageController.didMove(toParentViewController: self)
        
    }

    
    //Present ViewController At The Given Index
    func viewController(At index: Int) -> UIViewController? {
        
        if((self.menuBarView.dataArray.count == 0) || (index >= self.menuBarView.dataArray.count)) {
            
            return nil
        }
        
        let contentVC = storyboard?.instantiateViewController(withIdentifier: "ContentVC") as! ContentVC
        
        contentVC.strTitle = names[index]
        
        contentVC.pageIndex = index
        currentIndex = index

        return contentVC
        
    }
    
   
}











extension ViewController: MenuBarDelegate {
    
    func menuBarDidSelectItemAt(menu: MenuTabsView, index: Int) {
        
        if index != currentIndex {
           
            if index > currentIndex {
                self.pageController.setViewControllers([viewController(At: index)!], direction: .forward, animated: true, completion: nil)
            }else {
                self.pageController.setViewControllers([viewController(At: index)!], direction: .reverse, animated: true, completion: nil)
            }
            
            menuBarView.collView.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .centeredHorizontally, animated: true)

        }
        
    }
    
}


extension ViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! ContentVC).pageIndex
        
        if (index == 0) || (index == NSNotFound) {
            
            return nil
        }
        
        index -= 1
        return self.viewController(At: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! ContentVC).pageIndex
        
        if (index == names.count) || (index == NSNotFound) {
            
            return nil
        }
        
        index += 1
        return self.viewController(At: index)
        
    }
    
   
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if finished {
            
            if completed {
                
                let cvc = pageViewController.viewControllers!.first as! ContentVC
                let newIndex = cvc.pageIndex
                menuBarView.collView.selectItem(at: IndexPath.init(item: newIndex, section: 0), animated: true, scrollPosition: .centeredVertically)
                menuBarView.collView.scrollToItem(at: IndexPath.init(item: newIndex, section: 0), at: .centeredHorizontally, animated: true)
                
            }
        }
        
        
    }
    
    
}
