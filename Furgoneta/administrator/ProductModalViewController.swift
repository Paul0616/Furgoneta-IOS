//
//  ProductModalViewController.swift
//  Furgoneta
//
//  Created by Paul Oprea on 09/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class ProductModalViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var productNameTextField: UITextField!
    
    @IBOutlet weak var productUnitsTextField: UITextField!
    var index: Int?
    var productName: String?
    var productUnits: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.productNameTextField.delegate = self
        self.productUnitsTextField.delegate = self
        if(productName != nil) {
            productNameTextField.text = productName
        }
        if(productUnits != nil) {
            productUnitsTextField.text = productUnits
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func okBtn(_ sender: UIButton) {
       // dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        if textField == productNameTextField{
            productUnitsTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
