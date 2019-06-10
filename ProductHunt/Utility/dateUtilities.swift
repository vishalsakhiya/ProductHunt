//
//  dateUtilities.swift
//  ProductHunt
//
//  Created by Apple on 08/06/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

extension DateFormatter {
    convenience init(dateStyle: Style) {
        self.init()
        self.dateStyle = dateStyle
    }
    convenience init(timeStyle: Style) {
        self.init()
        self.timeStyle = timeStyle
    }
    convenience init(dateStyle: Style, timeStyle: Style) {
        self.init()
        self.dateStyle = dateStyle
        self.timeStyle = timeStyle
    }
}

extension Date {
    static let shortDate = DateFormatter(dateStyle: .short)
    static let fullDate = DateFormatter(dateStyle: .full)
    static let mediumDate = DateFormatter(dateStyle: .medium)
    static let longDate = DateFormatter(dateStyle: .long)
    
    static let shortTime = DateFormatter(timeStyle: .short)
    static let fullTime = DateFormatter(timeStyle: .full)
    static let mediumTime = DateFormatter(timeStyle: .medium)
    static let longTime = DateFormatter(timeStyle: .long)
    
    static let shortDateTime = DateFormatter(dateStyle: .short, timeStyle: .short)
    static let fullDateTime = DateFormatter(dateStyle: .full, timeStyle: .full)
    
    var fullDate:  String { return Date.fullDate.string(from: self) }
    var shortDate: String { return Date.shortDate.string(from: self) }
    var mediumDate: String { return Date.mediumDate.string(from: self) }
    var longDate: String { return Date.longDate.string(from: self) }
    
    var fullTime:  String { return Date.fullTime.string(from: self) }
    var shortTime: String { return Date.shortTime.string(from: self) }
    var longTime:  String { return Date.longTime.string(from: self) }
    var mediumTime: String { return Date.mediumTime.string(from: self) }
    
    var fullDateTime:  String { return Date.fullDateTime.string(from: self) }
    var shortDateTime: String { return Date.shortDateTime.string(from: self) }
}
