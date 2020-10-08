//
//  TimeInterval.swift
//  iTunesCatalog
//
//  Created by Dmitry on 03.10.2020.
//

import Foundation

extension TimeInterval {
       var minutesSeconds: String {
           return String(format:"%d:%02d", minute, second)
       }
       var minute: Int {
           return Int((self/60).truncatingRemainder(dividingBy: 60))
       }
       var second: Int {
           return Int(truncatingRemainder(dividingBy: 60))
       }
}
