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
    var realm : Realm!
    var categories : Results<Category>!
    let myRealm = MyRealm()
    
    let cellID = "CategoryCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        realm = try! Realm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        categories = realm.objects(Category.self)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! CategoryTableViewCell
        let category = categories[indexPath.row]
        cell.nameLabel.text = category.name
        cell.numLabel.text = String(category.questions.count)
        return cell
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
