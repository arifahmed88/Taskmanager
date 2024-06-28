//
//  UILabel+Extention.swift
//  TaskManager
//
//  Created by ArifAhmed on 28/6/24.
//

import UIKit

extension UILabel {
    
    func updateTextWithStrikeThrough( labelText:String, isStrikeThrough:Bool) {
        
        guard let textFont = self.font, let color = textColor else {return}
        
        if isStrikeThrough {
            let multipleAttributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.font: textFont,
                NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
            let attributeString = NSMutableAttributedString(string: labelText, attributes: multipleAttributes)
            self.attributedText = attributeString
            
        } else {
            
            let multipleAttributes: [NSAttributedString.Key : Any] = [
                NSAttributedString.Key.foregroundColor: color,
                NSAttributedString.Key.font: textFont]
            let attributeString = NSMutableAttributedString(string: labelText, attributes: multipleAttributes)
            self.attributedText = attributeString
        }
        
    }
}
