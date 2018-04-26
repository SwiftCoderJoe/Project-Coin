//
//  chooseVC.swift
//  CoinPrice
//
//  Created by Kids on 4/3/18.
//  Copyright © 2018 BytleBit. All rights reserved.
//
var cryptos = ["Bitcoin"]
import Foundation
import UIKit
class chooserVC:UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var table: UITableView!
    func segueMyDude(identifier: String) {
        performSegue(withIdentifier: "0", sender: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        table.dataSource = self
        table.delegate = self
        table.register(vcChooserCell.self, forCellReuseIdentifier: "LabelCell")
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! vcChooserCell
        print("bro")
        let fruitName = cryptos[indexPath.row]
        cell.name?.text = fruitName
        //cell.image?.image = UIImage(named: fruitName)
        
        return cell
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptos.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let identifier = indexPath.row
        chooserVC().segueMyDude(identifier: String(identifier))
    }

}

class vcChooserCell:UITableViewCell {
    @IBOutlet weak var name: UILabel!
}




