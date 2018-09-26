//
//  EndDayViewController.swift
//  Furgoneta
//
//  Created by Paul Oprea on 21/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EndDayViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var monetaryButton: UIButton!
    @IBOutlet weak var cashTextField: DesignableUItextField!
    @IBOutlet weak var cardTextField: DesignableUItextField!
    @IBOutlet weak var soldTextField: DesignableUItextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var documentIdLabel: UILabel!
    @IBOutlet weak var documentDateLabel: UILabel!
    
    var finished: Bool = false
    var adminView: Bool = false
    var documentId: Int?
    var documentDate: String?
    var addAction: Bool = false
    var textEditFields: [UITextField] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        monetaryButton.layer.cornerRadius = 20
        let add = UIBarButtonItem(title: "Salveaza", style: UIBarButtonItem.Style.plain, target: self, action: #selector(udateEndDay))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [spacer, add]
        cardTextField.delegate = self
        soldTextField.delegate = self
        textEditFields = [cardTextField, soldTextField]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.toolbar.isTranslucent = true
        navigationController?.toolbar.barTintColor = UIColor.orange
        navigationController?.toolbar.tintColor = UIColor.darkGray
        navigationController?.setToolbarHidden(adminView, animated: true)
        cashTextField.isEnabled = false
        cardTextField.isEnabled = !(finished)
        soldTextField.isEnabled = !(finished)
        if !addAction {
            documentIdLabel.text = "Nr. " + String(documentId!)
            documentDateLabel.text = "din " + documentDate!
            loadDocument()
        } else {
            addDocument()
        }
    }
    @objc func udateEndDay(){
        let param1 = [Constants.ID_KEY: self.documentId!, Constants.CASH_KEY: Double(cashTextField.text!)!, Constants.CARD_KEY: Double(cardTextField.text!)!, Constants.SOLD_KEY: Double(soldTextField.text!)!] as [String : Any]
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_SET_END_DAY, parameters: param1 as Parameters)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                   self.displayAlertMessages(userMessage: "Salvare efectuata")
                }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == nil || textField.text == "" {
            textField.text = "0.0"
        }
        if let doubleString = Double(textField.text!) {
            print(doubleString)
        } else {
            displayAlertMessages(userMessage: "Valoarea introdusa nu este corectă.")
            textField.becomeFirstResponder()
        }
       
    }
    
    func displayAlertMessages(userMessage: String){
                let myAlert = UIAlertController(title: "Informare", message: userMessage, preferredStyle: UIAlertController.Style.alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                myAlert.addAction(okAction)
                self.present(myAlert, animated: true, completion: nil)
    }
    
    func loadDocument(){
        SetContinueToolbar(field: cardTextField)
        SetContinueToolbar(field: soldTextField)
        let param = [Constants.ID_KEY: documentId] as [String: Int?]
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_FISA_INCHIDERE, parameters: param as Parameters)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    let cash: Double = swiftyJsonVar[0][Constants.CASH_KEY].doubleValue
                    let card: Double = swiftyJsonVar[0][Constants.CARD_KEY].doubleValue
                    let sold: Double = swiftyJsonVar[0][Constants.SOLD_KEY].doubleValue
                    self.cashTextField.text = String(cash)
                    self.cardTextField.text = String(card)
                    self.soldTextField.text = String(sold)
                    
                }
        }
    }
    func addDocument(){
        let preferences = UserDefaults.standard
        let param = [Constants.TYPE_KEY:Constants.DOCUMENT_TYPE_END_DAY, Constants.ID_KEY: preferences.object(forKey: Constants.USER_ID_KEY), Constants.LOCATION_NAME_KEY: preferences.object(forKey: Constants.LOCATION_NAME_KEY+Constants.ID_KEY)]
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_SET_NEW_DOCUMENT, parameters: param as Parameters)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    self.documentId = swiftyJsonVar[0][Constants.ID_KEY].intValue
                    self.addAction = false
                    self.documentIdLabel.text = "Nr. " + String(self.documentId!)
                    let date = Date()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.yyyy"
                    self.documentDate = formatter.string(from: date)
                    self.documentDateLabel.text = " din " + self.documentDate!
                   // self.loadDocument()
                    let param1 = [Constants.ID_KEY: self.documentId, Constants.CASH_KEY: 0, Constants.CARD_KEY: 0, Constants.SOLD_KEY: 0]
                    Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_SET_END_DAY, parameters: param1 as Parameters)
                        .responseJSON{(responseData) -> Void in
                            if responseData.result.value != nil {
                                
                            }
                    }
                }
        }
    }
    
    @IBAction func onClickMonetary(_ sender: Any) {
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if  segue.identifier == "showMonetary",
            let destinationNavigationController = segue.destination as? UINavigationController,
        let targetController = destinationNavigationController.topViewController as? MonetaryViewController
        {
            targetController.documentId = documentId
            targetController.adminView = adminView
        }
    }
    
    func SetContinueToolbar(field:DesignableUItextField) {
        let doneToolbar:UIToolbar = UIToolbar()
        
        if field == cardTextField {
            let cancelButton =  UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelButtonTapped(sender:)))
            cancelButton.tag = 0
            let continueButton = UIBarButtonItem(title: "Continue", style: UIBarButtonItem.Style.plain, target: self, action: #selector(continueButtonTapped(sender:)))
            doneToolbar.items=[cancelButton,
                UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil), continueButton
            ]
        } else {
            let cancelButton =  UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelButtonTapped(sender:)))
            cancelButton.tag = 1
            doneToolbar.items=[
                cancelButton,
                UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
            ]
        }
        
        doneToolbar.sizeToFit()
        field.inputAccessoryView = doneToolbar
    }
    
    @objc func continueButtonTapped(sender: UIBarButtonItem) {
        soldTextField.becomeFirstResponder()
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.contentOffset = CGPoint(x: 0, y: 260)
        })
    }
    @objc func cancelButtonTapped(sender: UIBarButtonItem) {
        if sender.tag == 0 {
            cardTextField.resignFirstResponder()
        }
        if sender.tag == 1 {
            soldTextField.resignFirstResponder()
        }
    }

}
