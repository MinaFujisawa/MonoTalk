//
//  Debouncer.swift
//  MonoTalk
//
//  Created by MINA FUJISAWA on 2017/11/18.
//  Copyright © 2017 MINA FUJISAWA. All rights reserved.
//

import Foundation

class Debouncer: NSObject {
    var callback: (() -> ())
    var delay: Double
    weak var timer: Timer?
    
    init(delay: Double, callback: @escaping (() -> ())) {
        self.delay = delay
        self.callback = callback
    }
    
    func call() {
        timer?.invalidate()
        let nextTimer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(fireNow), userInfo: nil, repeats: false)
        timer = nextTimer
    }
    
    @objc func fireNow() {
        self.callback()
    }
}
