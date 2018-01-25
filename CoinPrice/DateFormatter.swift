//
//  File.swift
//  CoinPrice
//
//  Created by Kids on 1/23/18.
//  Copyright © 2018 BytleBit. All rights reserved.
//


import Foundation
import Charts
let boi:Double = 50

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: Int(-(boi - value)), to: Date())!)
    }
}
