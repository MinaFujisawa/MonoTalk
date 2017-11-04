//
//  QuestionsPageViewController.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/10/30.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import RealmSwift

class QuestionsPageViewController: UIPageViewController {
    var selectedIndex : Int!
    var questions : List<Question>!
    
    var pageCollection = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        for i in 0..<questions.count {
            let detailVC = storyboard.instantiateViewController(withIdentifier: "questionPage") as! QuestionDetailViewController
            detailVC.question = questions[i]
            pageCollection.append(detailVC)
        }

        self.title = String(format: "%d / %d", selectedIndex+1, pageCollection.count)
        self.setViewControllers([pageCollection[selectedIndex]], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
        self.delegate = self
    }
}

extension QuestionsPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {

        guard let index = pageCollection.index(of: viewController) else { return nil }
        if (index - 1 < 0) {
            return nil
        }
        return pageCollection[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pageCollection.index(of: viewController) else { return nil }

        if (index + 1 >= pageCollection.count) {
            return nil
        }
        return pageCollection[index + 1]
    }
}

extension QuestionsPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (!completed) { return }
        // Add Title
        guard let viewController = self.viewControllers?.last else { return }
        guard let index = pageCollection.index(of: viewController) else { return }
        self.title = String(format: "%d / %d", index + 1, pageCollection.count)
    }
}
