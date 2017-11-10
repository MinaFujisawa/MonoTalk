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

    var category: Category!
    var questions: Results<Question>!
    var categoryID: String!

    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    let cellID = "QuestionCell"
    let sortCellID = "SortCell"
    var notificationToken: NotificationToken? = nil
    var currentSortMode = "Creation Date"


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        
        let nib = UINib(nibName: "SortCellXib", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: sortCellID)

        let realm = try! Realm()
        category = realm.object(ofType: Category.self, forPrimaryKey: categoryID)
        questions = category?.questions.sorted(byKeyPath: "date", ascending: true)

        self.title = category?.name
        tableView.dataSource = self
        tableView.delegate = self

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

        // Navigation bar
        addButton.image = UIImage(named: "navi_plus")!
    }

    deinit {
        notificationToken?.invalidate()
    }


    // MARK: segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToPages" {
            let pageVC = segue.destination as! QuestionsPageViewController
            let cell = sender as! QuestionTavleViewCell
            if let indexPath = self.tableView!.indexPath(for: cell) {
                pageVC.startIndex = indexPath.row - 1
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
        return questions.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Set cell
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: sortCellID, for: indexPath) as! SortCellXib
            cell.sortLabel.text = currentSortMode
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! QuestionTavleViewCell
            let question = questions[indexPath.row - 1]
            
            cell.questionLabel.text = question.questionBody
            cell.recordNumLabel.text = String(question.records.count)
            if question.note == nil {
                cell.noteIcon.image = nil
                cell.repositionStarIcon()
            } else {
                cell.noteIcon.image = UIImage(named: "icon_cell_note")
            }
            if question.isFavorited == false {
                cell.starIcon.image = nil
            } else {
                cell.starIcon.image = UIImage(named: "icon_star_filled")
            }
            cell.rateIcon.image = Question.Rate(rawValue: question.rate)?.rateImage
            
            return cell
        }
    }
}

extension QuestionTableViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 56
        } else {
            return 120
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            sortActionSheet()
        }
    }
    
    // MARK: Sort Action Sheet
    func sortActionSheet() {
        let alert: UIAlertController = UIAlertController(title: nil, message: "Sort questions by:", preferredStyle: .actionSheet)
        
        let creationDate = UIAlertAction(title: "Creation date", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            self.questions = self.category.questions.sorted(byKeyPath: "date", ascending: true)
            self.currentSortMode = "Creation date"
            self.tableView.reloadData()
        })
        
        let rate = UIAlertAction(title: "Rate", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            self.questions = self.category.questions.sorted(byKeyPath: "rate", ascending: false)
            self.currentSortMode = "Rate"
            self.tableView.reloadData()
        })
        
        let record = UIAlertAction(title: "Record", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            self.questions = self.category.questions.sorted(byKeyPath: "recordsNum", ascending: false)
            self.currentSortMode = "Record"
            self.tableView.reloadData()
        })
        
        let favo = UIAlertAction(title: "Favorite", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            self.questions = self.category.questions.sorted(byKeyPath: "isFavorited", ascending: false)
            self.currentSortMode = "Favorite"
            self.tableView.reloadData()
        })
        
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        alert.addAction(creationDate)
        alert.addAction(rate)
        alert.addAction(record)
        alert.addAction(favo)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }

}
