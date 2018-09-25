//
//  EditConsumerProductTableViewCell.swift
//  Furgoneta
//
//  Created by Paul Oprea on 24/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class EditConsumerProductViewController: UIViewController, UITextFieldDelegate {

    var productName: String?
    var quantity: Double?
    var documentTypeId: Int?
    var productId: Int?
    var docId: Int?
    var motivation: String?
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var motivationTextField: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        if productName != nil && productName != "" {
            productNameLabel.text = productName
        }
        if quantity != nil {
            quantityTextField.text = String(quantity!)
        }
        if motivation != nil {
            motivationTextField.text = motivation!
        }
    
    }

    @IBAction func onClickCancel(_ sender: Any) {
         dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickOk(_ sender: Any) {
        
    }
    
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let qtyString = quantityTextField.text
        //quantity = NumberFormatter().number(from: qtyString!)?.doubleValue
        quantity = Double(qtyString!)
        motivation = motivationTextField.text
//        print(quantity)
//        print(motivation)
        if quantity == nil {
            let myAlert = UIAlertController(title: "Eroare", message: "Cantitatea introdusa gresit", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
            myAlert.addAction(okAction)
            present(myAlert, animated: true, completion: nil)
            return false
        } else {
            return true
        }
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        if textField == motivationTextField {
            textField.resignFirstResponder()
        }
        return true
    }

}
