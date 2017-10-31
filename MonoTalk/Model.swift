//
//  Item.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/10/30.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import Foundation
import CoreMedia

struct Category {
    let uuid: String!
    var name: String!

    init(uuid: String!, name: String!) {
        self.uuid = uuid
        self.name = name
    }
}
struct Question {
    let uuid: String!
    var categoryId: String!
    let createdDate: Date? // Default questions will be nil
    var question: String!
    var exampleAnswer: String?
    var note: String?
    var isFavorited: Bool
    var feeling: Rate

    init(uuid: String!, categoryId: String!, question: String!, exampleAnswer: String?) {
        self.uuid = uuid
        self.categoryId = categoryId
        self.createdDate = Date()
        self.question = question
        self.exampleAnswer = exampleAnswer
        self.note = nil
        self.isFavorited = false
        self.feeling = Rate.soso
    }
}

enum Rate {
    case great
    case good
    case soso
    case notGood
    case bad
}

struct RecordAnswer {
    let uuid: String!
    let questionId: String!
    let date: Date!
    let url: URL!
    let duration: Float64 //not sure

//    if let url = Bundle.main.url(forResource: "small", withExtension: "mp4") {
//        let asset = AVAsset(url: url)
//
//        let duration = asset.duration
//        let durationTime = CMTimeGetSeconds(duration)
//
//        print(durationTime)
//    }
}
