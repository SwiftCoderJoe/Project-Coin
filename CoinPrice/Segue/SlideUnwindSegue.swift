//
//  SlideUnwindSegue.swift
//  CoinPrice
//
//  Created by Kids on 1/21/19.
//  Copyright © 2019 BytleBit. All rights reserved.
//

import UIKit

class SlideUnwindSegue: UIStoryboardSegue {
    override func perform() {
        let sourceVC = self.source.view as UIView
        let destVC = self.destination.view as UIView
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(destVC, aboveSubview: sourceVC)
        
        print("Animating...")
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            sourceVC.frame = sourceVC.frame.offsetBy(dx: screenWidth, dy: 0.0)
            destVC.frame = destVC.frame.offsetBy(dx: screenWidth, dy: 0.0)
        }) { (Finished) -> Void in
            self.source.dismiss(animated: false, completion: nil)
        }
    }
}
