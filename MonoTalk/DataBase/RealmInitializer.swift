//
//  RealmInitializer.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/04.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import Foundation
import RealmSwift

struct RealmInitializer {
    static func setUp() {
        let realm = try! Realm()

        let category1 = Category()
        category1.name = "Dairy1"

        let question1 = Question()
        question1.questionBody = "Dairy1 how's it going?"
        question1.exampleAnswer = "I'm great"
        question1.categoryID = category1.id

        let question2 = Question()
        question2.questionBody = "Dairy1 Are you fine?"
        question2.categoryID = category1.id

        category1.questions.append(question1)
        category1.questions.append(question2)
        
        let category2 = Category()
        category2.name = "Dairy2"
        
        let question3 = Question()
        question3.questionBody = "Dairy2 how's it going?"
        question3.exampleAnswer = "I'm great"
        question3.categoryID = category2.id
        
        let question4 = Question()
        question4.questionBody = "Dairy2 Are you fine?"
        question4.categoryID = category2.id
        
        category2.questions.append(question3)
        category2.questions.append(question4)

        try! realm.write {
            realm.add(category1)
            realm.add(category2)
        }
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
}
