//
//  Questions.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/10/30.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import Foundation

class DataSorce {
    func defaultCategorySet() -> [Category] {
        var category1 = Category(uuid: UUID().uuidString, name: "Dairy")
        var category2 = Category(uuid: UUID().uuidString, name: "Dairy2")
        return [category1, category2]
    }
    
    func defaultQuestions() -> [Question] {
        let categories = self.defaultCategorySet()
        var question1 = Question(uuid: UUID().uuidString, categoryId: categories[0].uuid, question: "How's it going?", exampleAnswer: nil)
        var question2 = Question(uuid: UUID().uuidString, categoryId: categories[0].uuid, question: "How was your weekend?", exampleAnswer: "It was awesome!")
        return [question1, question2]
    }
}

