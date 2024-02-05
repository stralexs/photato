//
//  UITextFieldExtension.swift
//  Photato
//
//  Created by Alexander Sivko on 20.09.23.
//

import UIKit

extension UITextField {
    func setIcon(_ image: UIImage?) {
        let iconView = UIImageView(frame: CGRect(x: 2, y: 2, width: 35, height: 35))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        iconView.contentMode = .scaleAspectFit
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
    
    func addBottomLineToTextField() {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.height - 2, width: self.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.tortilla.cgColor
        
        self.borderStyle = .none
        self.layer.addSublayer(bottomLine)
    }
}
