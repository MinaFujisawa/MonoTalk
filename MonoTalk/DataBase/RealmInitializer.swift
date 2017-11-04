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

        let category = Category()
        category.id = UUID().uuidString
        category.name = "Dairy1"

        let question1 = Question()
        question1.id = UUID().uuidString
        question1.questionBody = "Dairy1 how's it going?"
        question1.exampleAnswer = "I'm great"

        let question2 = Question()
        question2.id = UUID().uuidString
        question2.questionBody = "Dairy1 Are you fine?"

        category.questions.append(question1)
        category.questions.append(question2)
        
        let category2 = Category()
        category2.id = UUID().uuidString
        category2.name = "Dairy2"
        
        let question3 = Question()
        question3.id = UUID().uuidString
        question3.questionBody = "Dairy2 how's it going?"
        question3.exampleAnswer = "I'm great"
        
        let question4 = Question()
        question4.id = UUID().uuidString
        question4.questionBody = "Dairy2 Are you fine?"
        
        category2.questions.append(question3)
        category2.questions.append(question4)

        try! realm.write {
            realm.add(category)
            realm.add(category2)
        }
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
}
