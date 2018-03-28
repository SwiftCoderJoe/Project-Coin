//
//  ViewController.swift
//  CoinPrice
//
//  Created by Joey C on 11/21/17.
//  Copyright © 2017 BytleBit. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {
    let bitcoinHistory: [Int] = [8000, 8200, 8500, 8700, 9200, 9237]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func updateGraph() {
        var lineChartEntry = [ChartDataEntry]()
    }
}

