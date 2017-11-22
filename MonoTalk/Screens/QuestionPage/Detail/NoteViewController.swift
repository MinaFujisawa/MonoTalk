//
//  NoteViewController.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/10.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit
import RealmSwift

class NoteViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!

    var question: Question!
    let placeholderText = "Add note"

    override func viewDidLoad() {
        super.viewDidLoad()

        textView.setPadding()
        textView.delegate = self
        textView.font = UIFont.systemFont(ofSize: TextSize.normal.rawValue)

        if question.note != nil {
            textView.text = question.note
            textView.textColor = MyColor.darkText.value
        } else {
            textView.addPlaceholder(placeholderText)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        textView.becomeFirstResponder()
    }


    @IBAction func doneButton(_ sender: Any) {
        let realm = try! Realm()
        try! realm.write {
            if textView.textColor == MyColor.placeHolderText.value ||
                textView.text.isEmpty || !textView.text.isValidString() {
                question.note = nil
            } else {
                question.note = textView.text
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension NoteViewController: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = textView.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = textView.text.count > 0
        }

        if textView.text.isEmpty {
            textView.addPlaceholder(placeholderText)
        }
    }
}

