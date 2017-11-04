//
//  MyRealm.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/04.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import Foundation
import RealmSwift

class MyRealm {
    func addCategory(name: String) {
        let category = Category()
        category.id = UUID().uuidString
        category.name = name
        
        let realm = try! Realm()
        try! realm.write{ realm.add(category) }
    }
    
    func addRecord(data: Data) {
        let record = Record()
        record.id = UUID().uuidString
        record.recordData = data
        
        let realm = try! Realm()
        try! realm.write{ realm.add(record) }
    }
    
    static func loadSeedRealm(){
        var config = Realm.Configuration()
        let path = Bundle.main.path(forResource: "default", ofType: "realm")
        
        config.fileURL = URL(string:path!)
        config.readOnly = true
        Realm.Configuration.defaultConfiguration = config
        
        print(try! Realm().objects(Category.self).first?.name)
    }
    
    static func resetRealm() {
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
    }
}

