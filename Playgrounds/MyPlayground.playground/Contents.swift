//: Playground - noun: a place where people can play

import UIKit

var todaysDate:NSDate = NSDate()
var dateFormatter:DateFormatter = DateFormatter()
dateFormatter.dateFormat = "yyyy-MM-dd"
var todayString:String = dateFormatter.string(from: todaysDate as Date)



