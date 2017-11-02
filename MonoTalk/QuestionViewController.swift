//
//  ItemViewController.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/10/30.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import UIKit


class QuestionViewController: UIViewController {

    @IBAction func noteButton(_ sender: Any) {
    }
    @IBOutlet weak var sampleButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBAction func starButton(_ sender: Any) {
    }
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    
    var currentIndexTitle: String!
    var question : Question!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // UI
        recordButton.clipsToBounds = true
        recordButton.backgroundColor = MyColor.theme.value
        recordButton.dropShadow(isCircle: true)
        
        // Init contents
        questionLabel.text = question.question
        self.title = currentIndexTitle
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "recoder") {
            let modal = segue.destination as! RecorderModalViewController
//            modal.questionId = question.uuid //why bad access??
            modal.questionId = "aa"
        }
    }
    
}
