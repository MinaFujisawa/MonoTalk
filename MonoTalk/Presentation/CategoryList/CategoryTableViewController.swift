//
//  CategoryTableViewController.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/03.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    var realm: Realm!
    var categories: Results<Category>!

    var notificationToken: NotificationToken? = nil
    let cellID = "CategoryCell"
    let createCategorycellID = "CreateCategoryCellXib"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        realm = try! Realm()

        categories = realm.objects(Category.self)
        tableView.register(UINib(nibName: "CreateCategoryCellXib", bundle: nil), forCellReuseIdentifier: createCategorycellID)

//        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
//        self.view.addGestureRecognizer(longPressRecognizer)

        // MARK:Observe Results Notifications
        notificationToken = categories.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }

    func setUpUI() {
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        tableView.bounces = true
    }

    deinit {
        notificationToken?.invalidate()
    }

    //MARK: - Cell order
//    @objc func longPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
//
//        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
//
//            let touchPoint = longPressGestureRecognizer.location(in: self.view)
//            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
//                func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
//                    try! realm.write {
//                        let sourceObject = categories[sourceIndexPath.row]
//                        categories.remove(at: sourceIndexPath.row)
//                        categories.insert(sourceObject, at: destinationIndexPath.row)
//                    }
//                }
//
//                func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//                    return true
//                }
//            }
//        }
//    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 0))
//        headerView.backgroundColor = UIColor.white
//        return headerView
//    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if categories.count <= indexPath.row {
            // Create Category Cell
            tableView.deselectRow(at: indexPath, animated: true)
            let cell = tableView.dequeueReusableCell(withIdentifier: createCategorycellID, for: indexPath) as! CreateCategoryCellXib
            return cell
        } else {
            // Normal Cells
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CategoryTableViewCell
            let category = categories[indexPath.row]
            cell.nameLabel.text = category.name
            cell.numTextView.text = String(category.questions.count)
            return cell
        }
    }

    // MARK: segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToQuestions" {
            let questionsVC = segue.destination as! QuestionTableViewController
            let cell = sender as! CategoryTableViewCell
            if let indexPath = self.tableView!.indexPath(for: cell) {
                questionsVC.categoryID = categories[indexPath.row].id
            }
        }
    }
}


extension CategoryTableViewController: UITabBarControllerDelegate {

    // MARK: Edit actions
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.row < categories.count {
            let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) -> Void in
                self.isEditing = false
                self.deleteAlerm(deleteItem: self.categories[indexPath.row])
            }
            deleteAction.backgroundColor = MyColor.red.value

            let renameAction = UITableViewRowAction(style: .default, title: "Edit") { (action, indexPath) -> Void in
                self.isEditing = false
                self.showCategoryAlert(isEdit: true, category: self.categories[indexPath.row])
            }
            renameAction.backgroundColor = MyColor.lightText.value
            return [deleteAction, renameAction]
        } else {
            return .none
        }
    }
    
    // Disable swipe to delete for Create cell
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }


    // MARK: Create Category
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row >= categories.count {
            showCategoryAlert(isEdit: false, category: nil)
        }
    }

    func showCategoryAlert(isEdit: Bool, category: Category?) {

        var title = ""
        if isEdit {
            title = "Edit Category"
        } else {
            title = "Create Category"
        }
        let alertController: UIAlertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)

        alertController.addTextField { (textField: UITextField) in
            textField.placeholder = "Category name"
            if isEdit {
                textField.text = category?.name
            }
        }

        let okAction = UIAlertAction(title: "OK", style: .default) { (result) in

            let textField = alertController.textFields![0] as UITextField
            if (textField.text?.isEmpty)! {
                self.dismiss(animated: false, completion: nil)
            } else {
                //SAVE
                if isEdit {
                    try! self.realm.write {
                        category?.name = textField.text!
                    }
                } else {
                    let newCategory = Category()
                    newCategory.name = textField.text!
                    try! self.realm.write {
                        self.realm.add(newCategory)
                    }
                }
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }

    // MARK: Delete Category
    func deleteAlerm(deleteItem: Category) {
        let message = deleteItem.name + " will be deleted forever."
        let alert: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        let delete: UIAlertAction = UIAlertAction(title: "Delete Category", style: .destructive, handler: {
            (action: UIAlertAction!) -> Void in
            try! self.realm.write {
                self.realm.delete(deleteItem)
            }
        })

        alert.addAction(cancel)
        alert.addAction(delete)
        present(alert, animated: true, completion: nil)
    }
}

