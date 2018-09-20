//
//  HideShowPasswordTextField.swift
//  Furgoneta
//
//  Created by Paul Oprea on 11/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

protocol HideShowPasswordTextFieldDelegate: class {
    func isValidPassword(password: String) -> Bool
}

class HideShowPasswordTextField: UITextField, PasswordToggleVisibilityDelegate  {
    func viewWasToggled(passwordToggleVisibilityView: PasswordToggleVisibilityView, isSelected selected: Bool) {
        // hack to fix a bug with padding when switching between secureTextEntry state
        let hackString = self.text
        self.text = " "
        self.text = hackString
        
        // hack to save our correct font.  The order here is VERY finicky
        self.isSecureTextEntry = !selected
    }
    
    weak var passwordDelegate: HideShowPasswordTextFieldDelegate?
    private var passwordToggleVisibilityView: PasswordToggleVisibilityView!
    
    
    var preferredFont: UIFont? {
        didSet {
            self.font = preferredFont
            
            if self.isSecureTextEntry {
                self.font = nil
            }
        }
    }
    
    override var isSecureTextEntry: Bool {
        didSet {
            if !isSecureTextEntry {
                self.font = nil
                self.font = preferredFont
            }
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    private func setupViews() {
        let toggleFrame = CGRect(x: 0, y: 0, width: 66, height: frame.height)
        passwordToggleVisibilityView = PasswordToggleVisibilityView(frame: toggleFrame)
        passwordToggleVisibilityView.delegate = self
        
        self.keyboardType = .asciiCapable
        self.rightView = passwordToggleVisibilityView
        self.rightViewMode = .whileEditing
        
        self.font = self.preferredFont
//        self.addTarget(self, action: #selector(HideShowPasswordTextField.passwordTextChanged(_:)), forControlEvents: .EditingChanged)
        
        // if we don't do this, the eye flies in on textfield focus!
        self.rightView?.frame = self.rightViewRect(forBounds: self.bounds)
        
        // default eye state based on our initial secure text entry
        passwordToggleVisibilityView.eyeState = isSecureTextEntry ? .Closed : .Open
    }
    
    
}
