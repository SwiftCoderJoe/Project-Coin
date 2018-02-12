//
//  File.swift
//  CoinPrice
//
//  Created by Joey C on 2/1/18.
//  Copyright © 2018 BytleBit. All rights reserved.
//
import UIKit
import Foundation

class MaxLengthTextField: UITextField, UITextFieldDelegate {
    
    private var characterLimit: Int?
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
    }
    
    @IBInspectable var maxLength: Int {
        get {
            guard let length = characterLimit else {
                return Int.max
            }
            return length
        }
        set {
            characterLimit = newValue
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard string.count > 0 else {
            return true
        }
        
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(in: range, with: string)
        
        // 1. Here's the first change...
        return allowedIntoTextField(text: prospectiveText)
    }
    
    // 2. ...and here's the second!
    func allowedIntoTextField(text: String) -> Bool {
        return text.count <= maxLength
    }
    
}

class AllowedCharsTextField: MaxLengthTextField {
    
    // 1
    @IBInspectable var allowedChars: String = ""
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        // 2
        autocorrectionType = .no
    }
    
    // 3
    override func allowedIntoTextField(text: String) -> Bool {
        return super.allowedIntoTextField(text: text) &&
            text.containsOnlyCharactersIn(matchCharacters: allowedChars)
    }
    
}


// 4
private extension String {
    
    // Returns true if the string contains only characters found in matchCharacters.
    func containsOnlyCharactersIn(matchCharacters: String) -> Bool {
        let disallowedCharacterSet = CharacterSet(charactersIn: matchCharacters).inverted
        return self.rangeOfCharacter(from: disallowedCharacterSet) == nil
    }
    
}
