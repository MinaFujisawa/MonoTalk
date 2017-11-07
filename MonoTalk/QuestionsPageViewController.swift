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
    var categoryID: String!
    var notificationToken: NotificationToken? = nil
    var realm: Realm!

    var pageCollection = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self

        // Fetch questions data
        realm = try! Realm()
        let category = realm.object(ofType: Category.self, forPrimaryKey: categoryID)
        questions = category?.questions

        setUp()
    }

    func setUp() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // Create pageCollection
        if let questions = questions {
            for i in 0..<questions.count {
                let detailVC = storyboard.instantiateViewController(withIdentifier: "questionPage") as! QuestionDetailViewController
                detailVC.question = questions[i]
                pageCollection.append(detailVC)
            }
        }

        setTitle(index: currentIndex)
        currentIndex = startIndex
        self.setViewControllers([pageCollection[startIndex]], direction: .forward, animated: true, completion: nil)
    }

    // MARK: Action sheet
    @IBAction func menuButton(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "Edit", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            self.performSegue(withIdentifier: "GoToEdit", sender: self)
        })

        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let delete: UIAlertAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
            (action: UIAlertAction!) -> Void in
            self.remove()
        })

        alert.addAction(edit)
        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true, completion: nil)
    }

    func remove() {
        // Reove
        try! self.realm.write {
            realm.delete(questions![currentIndex])
        }
        pageCollection.remove(at: currentIndex)

        // Page optimize
        if currentIndex - 1 > 0 {
            self.setViewControllers([pageCollection[currentIndex - 1]], direction: .reverse, animated: false, completion: nil)
            currentIndex = currentIndex - 1
            setTitle(index: currentIndex)
        } else {
            if pageCollection.count > 0 {
                self.setViewControllers([pageCollection[currentIndex]], direction: .forward, animated: false, completion: nil)
                setTitle(index: currentIndex)
            } else {
                // No item
                _ = navigationController?.popViewController(animated: true)
            }
        }
    }

    func setTitle(index: Int) {
        self.title = String(format: "%d / %d", index + 1, pageCollection.count)
    }

    // MARK: segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToEdit" {
            let nav = segue.destination as! UINavigationController
            let editVC = nav.topViewController as! AddEditQuestionViewController
            if let questions = questions {
                editVC.existingQuestion = questions[self.currentIndex]
            }
        }
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
        currentIndex = index
        setTitle(index: currentIndex)
    }
}
