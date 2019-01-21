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
class coinChooserVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    func segueMyDude(identifier: String) {
        let id = "oof"
        self.performSegue(withIdentifier: id, sender: self)
    }
    
    func viewDidAppear() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(vcChooserCell.self, forCellReuseIdentifier: "LabelCell")
    }
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        print(tableView.dataSource as Any)
        tableView.register(vcChooserCell.self, forCellReuseIdentifier: "labelCell")
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! vcChooserCell
        print(cell)
        print("Loading...")
        let coinName = cryptos[indexPath.row]
        cell.name.text = coinName
        cell.cryptoImage.image = UIImage(named: cryptos[indexPath.row])
        
        return cell
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptos.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected")
        let identifier = indexPath.row
        segueMyDude(identifier: String(identifier))
    }

}

class vcChooserCell:UITableViewCell {
    @IBOutlet weak var cryptoImage: UIImageView!
    @IBOutlet weak var name: UILabel!
}




