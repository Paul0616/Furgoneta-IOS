//
//  DesignableUItextField.swift
//  Furgoneta
//
//  Created by Paul Oprea on 07/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
@IBDesignable
class DesignableUItextField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
//    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//    let paddingImage = UIImageView()
//    paddingImage.image = image
//    paddingImage.contentMode = .scaleAspectFit
//    paddingImage.frame = CGRect(x: 15, y: 0, width: 23, height: 40)
//    paddingView.addSubview(paddingImage)
//    self.leftView = paddingView
    func updateView(){
        if let image = leftImage {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.tintColor = color
            paddingView.addSubview(imageView)
            leftView = paddingView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ? placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
}
