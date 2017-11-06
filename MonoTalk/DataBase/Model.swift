//
//  Item.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/10/30.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import Foundation
import CoreMedia
import AVFoundation
import RealmSwift

class Category: Object {
    @objc dynamic var id = ""
    @objc dynamic var name = ""
    var questions = List<Question>()
    override static func primaryKey() -> String? {
        return "id"
    }
}
class Question: Object {
    @objc dynamic var id = ""
    @objc dynamic var date = Date()
    @objc dynamic var questionBody = ""
    @objc dynamic var exampleAnswer: String? = nil
    @objc dynamic var note: String? = nil
    @objc dynamic var isFavorited = false
    var rate = Rate.soso.rawValue
    let categoryName = ""
    var records = List<Record>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    enum Rate : Int {
        case great
        case good
        case soso
        case notGood
        case bad
    }
    
    var rateAsEnum: Rate {
        get {
            return Rate(rawValue: rate)!
        }
        set {
            rate = newValue.rawValue
        }
    }
}

class Record: Object {
    @objc dynamic var id = ""
    @objc dynamic var date = Date()
    override static func primaryKey() -> String? {
        return "id"
    }
}

