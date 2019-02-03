//
//  File.swift
//  CoinPrice
//
//  Created by Kids on 1/23/18.
//  Copyright © 2018 BytleBit. All rights reserved.
//


import Foundation
import Charts

public class DateValueFormatter: NSObject, IAxisValueFormatter {
    private let dateFormatter = DateFormatter()
    
    override init() {
        super.init()
        dateFormatter.dateFormat = "MM-dd"
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: Int(-(chartLength - Int(value))), to: Date())!)
    }
}
