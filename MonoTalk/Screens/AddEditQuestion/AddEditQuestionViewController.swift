//
//  EditQuestionViewController.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/06.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import RealmSwift

class AddEditQuestionViewController: UIViewController {

    @IBOutlet weak var questionTextView: UITextView!

    var isFromAdd = false // true: new, false: edit
    var existingQuestion: Question!
    var category: Category!
    let placeholderText = "e.g. How's it going?"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        questionTextView.delegate = self

        if isFromAdd {
            self.title = "Create new Question"
            questionTextView.addPlaceholder(placeholderText)
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.title = "Edit Question"
            questionTextView.text = existingQuestion.questionBody
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        questionTextView.becomeFirstResponder()
    }

    private func setupUI() {
        questionTextView.setPadding()
        questionTextView.font = UIFont.systemFont(ofSize: TextSize.normal.rawValue)
    }

    // MARK: Navi bar action
    @IBAction private func doneButton(_ sender: Any) {
        // MARK: Save
        let realm = try! Realm()
        if isFromAdd {
            // Add new question
            let newQuestion = Question()
            newQuestion.categoryID = category.id
            newQuestion.questionBody = questionTextView.text

            try! realm.write {
                category?.questions.append(newQuestion)
            }
        } else {
            // Update question
            try! realm.write {
                existingQuestion.questionBody = questionTextView.text
            }
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction private func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
// MARK: UITextViewDelegate
extension AddEditQuestionViewController: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = textView.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = textView.text.count > 0
        }
        
        if textView.text.isEmpty {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }
}
