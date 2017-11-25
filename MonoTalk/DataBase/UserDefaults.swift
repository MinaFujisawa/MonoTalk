//
//  UserDefaults.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/24.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import Foundation

//protocol KeyNamespaceable {
//    func namespaced<T: RawRepresentable>(_ key: T) -> String
//}
//
//extension KeyNamespaceable {
//
//    func namespaced<T: RawRepresentable>(_ key: T) -> String {
//        return "\(Self.self).\(key.rawValue)"
//    }
//}
//
//protocol BoolDefaultSettable : KeyNamespaceable {
//    associatedtype StringKey : RawRepresentable
//}
//
//extension BoolDefaultSettable where StringKey.RawValue == String {
//
//    func set(_ value: Bool, forKey key: StringKey) {
//        let key = namespaced(key)
//        UserDefaults.standard.set(value, forKey: key)
//    }
//
//    @discardableResult
//    func string(forKey key: StringKey) -> String? {
//        let key = namespaced(key)
//        return UserDefaults.standard.string(forKey: key)
//    }
//}

// MARK: Keys
extension UserDefaults {
    enum StringKey : String {
        case firstLaunch
        case firstRecord
    }
}
