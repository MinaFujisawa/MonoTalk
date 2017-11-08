//
//  QuestionTableViewController.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/03.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import RealmSwift

class QuestionTableViewController: UIViewController {
    
    var questions: List<Question>!
    var categoryID: String!

    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var sortContainerView: UIView!
    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var addButton: UIBarButtonItem!
    let cellID = "QuestionCell"
    var notificationToken: NotificationToken? = nil


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()

        let realm = try! Realm()
        let category = realm.object(ofType: Category.self, forPrimaryKey: categoryID)
        questions = category?.questions

        self.title = category?.name
        tableView.dataSource = self

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

    func setUpUI() {
        // tableView
//        tableView.estimatedRowHeight = 90
//        tableView.rowHeight = UITableViewAutomaticDimension
        // TODO : fix this
//        tableViewHeightConstraint.constant = tableView.contentSize.height

        // sort
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: sortContainerView.frame.height, width: self.view.frame.width, height: 1.0)
        bottomLine.backgroundColor = UIColor.black.cgColor
        sortContainerView.layer.addSublayer(bottomLine)

        // Navigation bar
        addButton.image = UIImage(named: "navi_plus")!
    }

    deinit {
        notificationToken?.invalidate()
    }


    @objc func openMenu() {

    }



    // MARK: segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToPages" {
            let pageVC = segue.destination as! QuestionsPageViewController
            let cell = sender as! QuestionTavleViewCell
            if let indexPath = self.tableView!.indexPath(for: cell) {
                pageVC.startIndex = indexPath.row
                pageVC.categoryID = categoryID
                tableView.deselectRow(at: indexPath, animated: true)
            }
        } else if segue.identifier == "GoToAdd" {
            let nav = segue.destination as! UINavigationController
            let editVC = nav.topViewController as! AddEditQuestionViewController
            editVC.isFromAdd = true
            editVC.categoryID = categoryID
        }

    }
}

extension QuestionTableViewController: UITableViewDataSource {
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! QuestionTavleViewCell
        let question = questions[indexPath.row]

        // Set cell
        cell.questionLabel.text = question.questionBody
        cell.recordNumLabel.text = String(question.records.count)
        if question.note == nil {
            cell.noteIcon.image = nil
            cell.repositionStarIcon()
        }
        if question.isFavorited == false {
            cell.starIcon.image = nil
        }
        cell.rateIcon.image = Question.Rate(rawValue: question.rate)?.rateImage

        return cell
    }
}
