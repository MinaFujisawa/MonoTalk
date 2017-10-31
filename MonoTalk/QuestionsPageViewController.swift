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

        let question1 = Question(uuid: UUID().uuidString, categoryId: "1", question: "How's it going?", exampleAnswer: nil)
        let question2 = Question(uuid: UUID().uuidString, categoryId: "1", question: "How was your weekend?", exampleAnswer: "It was awesome!")
        let question3 = Question(uuid: UUID().uuidString, categoryId: "2", question: "How was your weekend?", exampleAnswer: "It was awesome!")
        _ = Question(uuid: UUID().uuidString, categoryId: "2", question: "Dairy1 question", exampleAnswer: "It was awesome!")

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let questionVC1 = storyboard.instantiateViewController(withIdentifier: "storyPage") as! QuestionViewController
        questionVC1.question = question1

        let questionVC2 = storyboard.instantiateViewController(withIdentifier: "storyPage") as! QuestionViewController
        questionVC2.question = question2

        let questionVC3 = storyboard.instantiateViewController(withIdentifier: "storyPage") as! QuestionViewController
        questionVC3.question = question3

        pageCollection = [questionVC1, questionVC2, questionVC3]

        self.setViewControllers([questionVC1], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
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
