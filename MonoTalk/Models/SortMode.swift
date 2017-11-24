//
//  File.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/16.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import Foundation
enum SortMode: String {
    case createdDate
    case rate
    case isFavorited
    case recordsNum
    
    static let allValues = [createdDate, rate, isFavorited, recordsNum]

    var title: String {
        switch self {
        case .createdDate:
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
        case .createdDate:
            return false
        case .rate:
            return false
        case .isFavorited:
            return false
        case .recordsNum:
            return false
        }
    }
}
