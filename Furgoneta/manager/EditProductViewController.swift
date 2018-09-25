//
//  EditProductViewController.swift
//  Furgoneta
//
//  Created by Paul Oprea on 24/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit


class EditProductViewController: UIViewController, UITextFieldDelegate {

    var productName: String?
    var quantity: Double?
    var documentTypeId: Int?
    var productId: Int?
    var docId: Int?
    
    @IBOutlet weak var productNamelabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    @IBOutlet weak var quantityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        if productName != nil && productName != "" {
            productNamelabel.text = productName
        }
        if quantity != nil {
            quantityTextField.text = String(quantity!)
        }
        if documentTypeId != nil && documentTypeId != 0 {
            if documentTypeId == 1 {
                subtitleLabel.text = "Cantitatea dorita:"
            }
            if documentTypeId == 4 {
                subtitleLabel.text = "Cantitatea gasita la inventar:"
            }
        }
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onClickOk(_ sender: Any) {
   
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let qtyString = quantityTextField.text
        //quantity = NumberFormatter().number(from: qtyString!)?.doubleValue
        quantity = Double(qtyString!)
        //print(quantity)
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
        if textField == quantityTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}
