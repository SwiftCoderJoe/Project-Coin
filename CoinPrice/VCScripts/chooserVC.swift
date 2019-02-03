//
//  chooseVC.swift
//  CoinPrice
//
//  Created by Kids on 4/3/18.
//  Copyright © 2018 BytleBit. All rights reserved.
//
var cryptos = ["Bitcoin", "Bitcoin Gold"]
import Foundation
import UIKit
class coinChooserVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func returnFromSegueActions(sender: UIStoryboardSegue) {
        
    }
    
    override func segueForUnwinding(to toViewController: UIViewController, from fromViewController: UIViewController, identifier: String?) -> UIStoryboardSegue {
        if let id = identifier{
            if id == "oofUnwind" {
                let unwindSegue = SlideUnwindSegue(identifier: id, source: fromViewController, destination: toViewController, performHandler: { () -> Void in
                    
                })
                return unwindSegue
            }
        }
        
        return super.segueForUnwinding(to: toViewController, from: fromViewController, identifier: identifier)!
    }
    
    func segueMyDude(identifier: String) {
        self.performSegue(withIdentifier: identifier, sender: self)
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
        let identifier = indexPath.row
        segueMyDude(identifier: String(identifier))
    }

}

class vcChooserCell:UITableViewCell {
    @IBOutlet weak var cryptoImage: UIImageView!
    @IBOutlet weak var name: UILabel!
}




