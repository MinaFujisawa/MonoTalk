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
    var startIndex: Int!
    var currentIndex: Int!
    var questions: List<Question>?
    var categoryID : String!
    var notificationToken: NotificationToken? = nil

    var pageCollection = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        self.delegate = self
        
        let realm = try! Realm()
        let category = realm.object(ofType: Category.self, forPrimaryKey: categoryID)
        questions = category?.questions
        
        // MARK:Observe Results Notifications
        notificationToken = questions?.observe { changes in
            switch changes {
            case .initial:
                print("initial")
            case .update(_, let deletions, let insertions, let modifications):
                print("update")
            case .error(let error):
                fatalError("\(error)")
            }
        }
        setUp()
        
    }
    
    func setUp(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Create pageCollection
        if let questions = questions {
            for i in 0..<questions.count {
                let detailVC = storyboard.instantiateViewController(withIdentifier: "questionPage") as! QuestionDetailViewController
                detailVC.question = questions[i]
                pageCollection.append(detailVC)
            }
        }
        
        self.title = String(format: "%d / %d", startIndex + 1, pageCollection.count)
        currentIndex = startIndex
        self.setViewControllers([pageCollection[startIndex]], direction: .forward, animated: true, completion: nil)
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

    @IBAction func menuButton(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "Edit", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            self.goToEdit()
        })

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let delete: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (action: UIAlertAction!) -> Void in
            //
        })

        alert.addAction(edit)
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true, completion: nil)
    }
    
    func goToEdit() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let editVC = storyBoard.instantiateViewController(withIdentifier: "EditQuestion") as! AddQuestionViewController
        editVC.existingQuestion = self.questions?[self.currentIndex]

        // add animation (bottom to top)
//        let transition:CATransition = CATransition()
//        transition.duration = 0.5
//        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromBottom
//        self.navigationController!.view.layer.add(transition, forKey: kCATransition)

        self.navigationController?.pushViewController(editVC, animated: true)
    }
}

extension QuestionsPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if (!completed) { return }
        // Add Title
        guard let viewController = self.viewControllers?.last else { return }
        guard let index = pageCollection.index(of: viewController) else { return }
        currentIndex = index
        self.title = String(format: "%d / %d", currentIndex + 1, pageCollection.count)
    }
}
