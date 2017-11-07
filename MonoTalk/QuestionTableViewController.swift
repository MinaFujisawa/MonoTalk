//
//  QuestionTableViewController.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/03.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import RealmSwift

class QuestionTableViewController: UITableViewController {
    var questions: List<Question>!
    var categoryID: String!

    let cellID = "QuestionCell"
    var notificationToken: NotificationToken? = nil

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()

        let realm = try! Realm()
        let category = realm.object(ofType: Category.self, forPrimaryKey: categoryID)
        questions = category?.questions

        // MARK:Observe Results Notifications
        notificationToken = questions.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }

    deinit {
        notificationToken?.invalidate()
    }
    
    // MARK: Navigation bar
    func setUp() {
        //TODO: add filter menu
        addButton.image = UIImage(named: "navi_plus")!
        menuButton.image = UIImage(named: "navi_menu")!
    }
    
    @IBAction func menuButton(_ sender: Any) {
    }

    @objc func openAddQuestion() {
        let editQuestionVC = AddEditQuestionViewController()
        self.navigationController?.pushViewController(editQuestionVC, animated: true)
    }

    @objc func openMenu() {

    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! QuestionTavleViewCell
        let question = questions[indexPath.row]

        // Set cell
        cell.questionLabel.text = question.questionBody
        cell.recordNumLabel.text = String(question.records.count)
        if question.exampleAnswer == nil {
            cell.exampleIcon.image = nil
        }
        if question.note == nil {
            cell.noteIcon.image = nil
        }
        cell.rateIcon.image = Question.Rate(rawValue: question.rate)?.rateImage

        return cell
    }

// MARK: segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToDetail" {
            let pageVC = segue.destination as! QuestionsPageViewController
            let cell = sender as! QuestionTavleViewCell
            if let indexPath = self.tableView!.indexPath(for: cell) {
                pageVC.startIndex = indexPath.row
                pageVC.categoryID = categoryID
            }
        } else if segue.identifier == "GoToAdd"{
            let nav = segue.destination as! UINavigationController
            let editVC = nav.topViewController as! AddEditQuestionViewController
            editVC.isFromAdd = true
            editVC.categoryID = categoryID
        }
        
    }

}
