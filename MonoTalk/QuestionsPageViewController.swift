//
//  QuestionsPageViewController.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/10/30.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit

class QuestionsPageViewController: UIPageViewController {
    var pageCollection: [UIViewController]!
    override func viewDidLoad() {
        super.viewDidLoad()
        let question1 = Question(uuid: UUID().uuidString, categoryId: "1", question: "1.How's it going?", exampleAnswer: nil)
        let question2 = Question(uuid: UUID().uuidString, categoryId: "1", question: "2.How was your weekend?", exampleAnswer: "It was awesome!")
        let question3 = Question(uuid: UUID().uuidString, categoryId: "2", question: "3.How was your weekend?", exampleAnswer: "It was awesome!")
        let question4 = Question(uuid: UUID().uuidString, categoryId: "2", question: "4. Dairy1 question", exampleAnswer: "It was awesome!")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let questionVC1 = storyboard.instantiateViewController(withIdentifier: "questionPage") as! QuestionViewController
        questionVC1.question = question1

        let questionVC2 = storyboard.instantiateViewController(withIdentifier: "questionPage") as! QuestionViewController
        questionVC2.question = question2

        let questionVC3 = storyboard.instantiateViewController(withIdentifier: "questionPage") as! QuestionViewController
        questionVC3.question = question3

        let questionVC4 = storyboard.instantiateViewController(withIdentifier: "questionPage") as! QuestionViewController
        questionVC4.question = question4

        pageCollection = [questionVC1, questionVC2, questionVC3, questionVC4]

        self.title = String(format: "%d / %d", 1, pageCollection.count)
        self.setViewControllers([questionVC1], direction: .forward, animated: true, completion: nil)
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
