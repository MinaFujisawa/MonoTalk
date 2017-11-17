//
//  File.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/16.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import Foundation
enum SortMode: String {
    case date
    case rate
    case isFavorited
    case recordsNum
    
    static let allValues = [date, rate, isFavorited, recordsNum]

    var title: String {
        switch self {
        case .date:
            return "Creation date"
        case .rate:
            return "Rate"
        case .isFavorited:
            return "Favorite"
        case .recordsNum:
            return "Record"
        }
    }

    var acsending: Bool {
        switch self {
        case .date:
            return true
        case .rate:
            return false
        case .isFavorited:
            return false
        case .recordsNum:
            return false
        }
    }
}
