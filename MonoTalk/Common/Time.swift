//
//  Time.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/10/31.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import Foundation
import AVFoundation

class Time {
    static func getFormattedTime(timeInterval : TimeInterval) -> String {
        //        let hours = Int(totalSeconds / 3600)
        let m = Int((timeInterval.truncatingRemainder(dividingBy: 3600)) / 60)
        let s = Int(timeInterval.truncatingRemainder(dividingBy: 60))
        return String(format: "%02d:%02d", m, s)
    }
    
    static func getFormattedDate(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd h:mm a"
        dateFormatter.amSymbol = "am"
        dateFormatter.pmSymbol = "pm"
        return dateFormatter.string(from:date)
    }
    
    static func getDuration(url : URL) -> Float64{
        let asset = AVURLAsset(url: url, options: nil)
        let audioDuration = asset.duration
        return CMTimeGetSeconds(audioDuration)
    }
}
