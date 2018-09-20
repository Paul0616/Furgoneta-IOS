//
//  PasswordToggleVisibilityView.swift
//  Furgoneta
//
//  Created by Paul Oprea on 11/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//
import Foundation
import UIKit

protocol PasswordToggleVisibilityDelegate: class {
    func viewWasToggled(passwordToggleVisibilityView: PasswordToggleVisibilityView, isSelected selected: Bool)
}

class PasswordToggleVisibilityView: UIView {

    private let eyeOpenedImage: UIImage
    private let eyeClosedImage: UIImage
    private let eyeButton: UIButton

    enum EyeState {
        case Open
        case Closed
    }
    
    var eyeState: EyeState {
        set {
            eyeButton.isSelected = newValue == .Open
        }
        get {
            return eyeButton.isSelected ? .Open : .Closed
        }
    }
    
    override var tintColor: UIColor!{
        didSet {
            eyeButton.tintColor = tintColor
        }
    }
    weak var delegate: PasswordToggleVisibilityDelegate?
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override init(frame: CGRect) {
        self.eyeOpenedImage = UIImage(named: "ic_eye_open")!.withRenderingMode(.alwaysTemplate)
        self.eyeClosedImage = UIImage(named: "ic_eye_closed")!
        self.eyeButton = UIButton(type: .custom)
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use init with coder.")
    }
    
    private func setupViews() {
        let padding: CGFloat = 10
        let buttonWidth = frame.width / 2 - padding
        let buttonFrame = CGRect(x: buttonWidth + padding, y: 0, width: buttonWidth, height: frame.height)
        eyeButton.frame = buttonFrame
        eyeButton.backgroundColor = UIColor.clear
        eyeButton.adjustsImageWhenHighlighted = false
        eyeButton.setImage(self.eyeClosedImage, for: .normal)
        eyeButton.setImage(self.eyeOpenedImage.withRenderingMode(.alwaysTemplate), for: .selected)
        eyeButton.addTarget(self, action: #selector(eyeButtonPressed), for: .touchUpInside)
        eyeButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        eyeButton.tintColor = self.tintColor
        self.addSubview(eyeButton)
    }
    
    @objc func eyeButtonPressed(sender: AnyObject) {
        eyeButton.isSelected = !eyeButton.isSelected
        delegate?.viewWasToggled(passwordToggleVisibilityView: self, isSelected: eyeButton.isSelected)
    }
}
