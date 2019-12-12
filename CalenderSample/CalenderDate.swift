//
//  CalenderDate.swift
//  CalenderSample
//
//  Created by cano on 2019/12/11.
//  Copyright © 2019 deskplate. All rights reserved.
//

import UIKit

struct CalenderDate {
    var year: Int
    var month: Int
    var day: Int

    init() {
        let calendar    = Calendar(identifier: .gregorian)
        let date        = calendar.dateComponents([.year, .month, .day], from: Date())
        year            = date.year!
        month           = date.month!
        day             = date.day!
    }
    
    init(_ monthCounter: Int) {
        let calendar    = Calendar(identifier: .gregorian)
        let date        = calendar.date(byAdding: .month, value: monthCounter, to: Date())
        let newDate     = calendar.dateComponents([.year, .month, .day], from: date!)
        year            = newDate.year!
        month           = newDate.month!
        day             = newDate.day!
    }
}
