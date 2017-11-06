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
    var questions : List<Question>!
    
    let cellID = "QuestionCell"
    
    @IBAction func menuButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
                pageVC.selectedIndex = indexPath.row
                pageVC.questions = questions
            }
        }
    }
    
}
