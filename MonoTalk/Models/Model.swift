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
    @objc dynamic var imageName = ""
    @objc dynamic var createdDate = Date()
    var questions = List<Question>()
    override static func primaryKey() -> String? {
        return "id"
    }
}
class Question: Object {
    @objc dynamic var id = UUID().uuidString
    @objc dynamic var createdDate = Date()
    @objc dynamic var questionBody = ""
    @objc dynamic var note: String? = nil
    @objc dynamic var isFavorited = false
    @objc dynamic var categoryID = ""
    @objc dynamic var rate = Rate.soso.rawValue
    var records = List<Record>()
    @objc dynamic var recordsNum = 0

    override static func primaryKey() -> String? {
        return "id"
    }

    enum Rate: Int {
        case bad
        case notGood
        case soso
        case good
        case great

        var rateImage: UIImage {
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

        var tutorialText: String {
            switch self {
            case .bad:
                return "Oh no!"
            case .notGood:
                return "Difficult"
            case .soso:
                return "So-so"
            case .good:
                return "Not bad"
            case .great:
                return "Easy!"
            }
        }

        static let allValues = [bad, notGood, soso, good, great]
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
    @objc dynamic var createdDate = Date()
    @objc dynamic var fileSize: Int64 = 0
    override static func primaryKey() -> String? {
        return "id"
    }

    static let fileExtension = ".caf"
}

