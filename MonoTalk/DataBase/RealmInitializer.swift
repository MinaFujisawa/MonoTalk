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
        
        let path : String = Bundle.main.path(forResource: "seed", ofType: "csv")!
        let stream = InputStream(fileAtPath: path)!
        var categoryNames = [String]()
        var categoris = [Category]()
        
        // Read CSV
        for row in try! CSV(stream: stream, hasHeaderRow: true) {
            let categoryName = row[0]
            let questionBody = row[1]
            
            if categoryNames.contains(categoryName) {
                let question = Question()
                question.questionBody = questionBody
                guard let categoryIndex = categoryNames.index(of: categoryName) else { return }
                
                try! realm.write {
                    categoris[categoryIndex].questions.append(question)
                }
            } else{
                let category = Category()
                category.name = categoryName
                
                let question = Question()
                question.questionBody = questionBody
                category.questions.append(question)
                
                categoryNames.append(categoryName)
                categoris.append(category)
                
                try! realm.write {
                    realm.add(category)
                }
            }
        }
        let realmPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] + "/default"
        try! Realm().writeCopy(toFile: URL(string: realmPath)!, encryptionKey: Data(base64Encoded: "default"))
    }
}
