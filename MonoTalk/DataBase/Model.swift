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
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var name = ""
    var questions = List<Question>()
    override static func primaryKey() -> String? {
        return "id"
    }
}
class Question: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var date = Date()
    @objc dynamic var questionBody = ""
    @objc dynamic var note: String? = nil
    @objc dynamic var isFavorited = false
    @objc dynamic var categoryID = ""
    @objc dynamic var rate = Rate.soso.rawValue
    var records = List<Record>()

    override static func primaryKey() -> String? {
        return "id"
    }

    enum Rate: Int {
        case great
        case good
        case soso
        case notGood
        case bad
        
        var rateImage : UIImage {
            switch self {
            case .great:
                return UIImage(named: "rate_great")!
            case .good:
                return UIImage(named: "rate_good")!
            case .soso:
                return UIImage(named: "rate_soso")!
            case .notGood:
                return UIImage(named: "rate_notGood")!
            case .bad:
                return UIImage(named: "rate_bad")!
            }
        }
        
        static let allValues = [great, good, soso, notGood, bad]
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

