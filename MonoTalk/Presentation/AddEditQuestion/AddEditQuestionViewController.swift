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

    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var noteTextView: UITextView!

    var isFromAdd = false // true: new, false: edit
    var existingQuestion: Question!
    var categoryID: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        questionTextView.tag = 1000

        if isFromAdd {
            self.title = "Create new Question"
            setPlaceHolder()
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            self.title = "Edit Question"
            questionTextView.text = existingQuestion.questionBody
            // TODO: Set PH
            noteTextView.text = existingQuestion.note ?? ""
        }
    }

    func setUpUI() {
        view.backgroundColor = MyColor.bluishGrayBackground.value

        questionTextView.delegate = self
        noteTextView.delegate = self

        // TextView
        questionTextView.setPadding()
        noteTextView.setPadding()
        questionTextView.setTopAndBottomBorder()
        noteTextView.setTopAndBottomBorder()

        questionTextView.textColor = MyColor.placeHolderText.value
        noteTextView.textColor = MyColor.placeHolderText.value
        questionTextView.font = UIFont.systemFont(ofSize: TextSize.normal.rawValue)
        noteTextView.font = UIFont.systemFont(ofSize: TextSize.normal.rawValue)

        // Label
        questionLabel.textColor = MyColor.darkText.value
        noteLabel.textColor = MyColor.darkText.value
        questionLabel.font = UIFont.systemFont(ofSize: TextSize.heading.rawValue)
        noteLabel.font = UIFont.systemFont(ofSize: TextSize.heading.rawValue)
    }

    func setPlaceHolder() {
        // TODO: set valid place holder
        questionTextView.text = "Placeholder"
        noteTextView.text = "Placeholder"
    }

    // MARK: Navi bar action
    @IBAction func doneButton(_ sender: Any) {
        // MARK: Save
        let realm = try! Realm()
        if isFromAdd {
            // Add new question
            let newQuestion = Question()
            newQuestion.questionBody = questionTextView.text
            newQuestion.categoryID = categoryID

            if noteTextView.textColor == MyColor.placeHolderText.value {
                newQuestion.note = nil
            } else {
                newQuestion.note = noteTextView.text
            }

            let category = realm.object(ofType: Category.self, forPrimaryKey: categoryID)
            try! realm.write {
                category?.questions.append(newQuestion)
            }
        } else {
            // Update question
            try! realm.write {
                existingQuestion.questionBody = questionTextView.text

                if noteTextView.textColor == MyColor.placeHolderText.value {
                    existingQuestion.note = nil
                } else {
                    existingQuestion.note = noteTextView.text
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }

    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension AddEditQuestionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == MyColor.placeHolderText.value {
            textView.text = nil
            textView.textColor = MyColor.darkText.value
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            setPlaceHolder()
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        if textView.tag == 1000 {
            if textView.text.isEmpty {
                self.navigationItem.rightBarButtonItem?.isEnabled = false
            } else {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
            }
        }
    }
}