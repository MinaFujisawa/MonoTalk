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
    
    var question : Question!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()

    }

    func setUpUI() {
//        recordButton.layer.cornerRadius = recordButton.frame.width / 2
        recordButton.clipsToBounds = true
        recordButton.backgroundColor = MyColor.theme.value
        recordButton.dropShadow(isCircle: true)
    }

}
