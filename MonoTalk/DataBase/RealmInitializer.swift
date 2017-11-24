//
//  RealmInitializer.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/04.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import Foundation
import RealmSwift
import CSV

struct RealmInitializer {
    static func setUp() {
        let realm = try! Realm()

        // Read Category CSV
        let categoriesPath: String = Bundle.main.path(forResource: "seed_category", ofType: "csv")!
        let categoriesStream = InputStream(fileAtPath: categoriesPath)!

        for row in try! CSV(stream: categoriesStream, hasHeaderRow: true) {
            let category = Category()
            category.id = row[0]
            category.name = row[1]
            category.imageName = row[2]

            try! realm.write {
                realm.add(category)
            }
        }
        
        // Read Questions CSV
        let questionsPath: String = Bundle.main.path(forResource: "seed_questions", ofType: "csv")!
        let questionsStream = InputStream(fileAtPath: questionsPath)!
        
        for row in try! CSV(stream: questionsStream, hasHeaderRow: true) {
            let question = Question()
            question.categoryID = row[0]
            question.questionBody = row[2]
            
            if let category = realm.object(ofType: Category.self, forPrimaryKey: row[0]) {
                try! realm.write {
                    category.questions.append(question)
                }
            }
        }
        
        let realmPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/default"
        try! Realm().writeCopy(toFile: URL(string: realmPath)!, encryptionKey: Data(base64Encoded: "default"))
    }
}

