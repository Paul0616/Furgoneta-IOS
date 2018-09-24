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
        if documentTypeId != nil && documentTypeId != 0 {
            if documentTypeId == 1 {
                subtitleLabel.text = "Cantitatea dorita:"
            }
            if documentTypeId == 3 {
                subtitleLabel.text = "Cantitatea gasita la inventar:"
            }
        }
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        if textField == quantityTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}
