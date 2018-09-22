//
//  MonetaryViewController.swift
//  Furgoneta
//
//  Created by Paul Oprea on 21/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MonetaryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var textField500L: UITextField!
    @IBOutlet weak var textField200L: UITextField!
    @IBOutlet weak var textField100L: UITextField!
    @IBOutlet weak var textField50L: UITextField!
    @IBOutlet weak var textField10L: UITextField!
    @IBOutlet weak var textField5L: UITextField!
    @IBOutlet weak var textField1L: UITextField!
    @IBOutlet weak var textField50B: UITextField!
    @IBOutlet weak var textField10B: UITextField!
    @IBOutlet weak var textField5B: UITextField!
    @IBOutlet weak var textField1B: UITextField!
    @IBOutlet weak var stackViewsMonetar: UIStackView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var label500L: UILabel!
    @IBOutlet weak var label200L: UILabel!
    @IBOutlet weak var label100L: UILabel!
    @IBOutlet weak var label50L: UILabel!
    @IBOutlet weak var label10L: UILabel!
    @IBOutlet weak var label5L: UILabel!
    @IBOutlet weak var label1L: UILabel!
    @IBOutlet weak var label50B: UILabel!
    @IBOutlet weak var label10B: UILabel!
    @IBOutlet weak var label5B: UILabel!
    @IBOutlet weak var label1B: UILabel!
    @IBOutlet weak var labelTotal: UILabel!

    var money = [MoneyModel]()
    
 //   let textFieldTags = [50000, 20000, 10000, 5000, 1000, 500, 100, 50, 10, 5, 1]
    
    var finished: Bool = false
    var documentId: Int?
    
    var currentTextField: UITextField?
    override func viewDidLoad() {
        super.viewDidLoad()
        SetKeyboardWithContinueToolbar(sender: textField500L)
        SetKeyboardWithContinueToolbar(sender: textField200L)
        SetKeyboardWithContinueToolbar(sender: textField100L)
        SetKeyboardWithContinueToolbar(sender: textField50L)
        SetKeyboardWithContinueToolbar(sender: textField10L)
        SetKeyboardWithContinueToolbar(sender: textField5L)
        SetKeyboardWithContinueToolbar(sender: textField1L)
        SetKeyboardWithContinueToolbar(sender: textField50B)
        SetKeyboardWithContinueToolbar(sender: textField10B)
        SetKeyboardWithContinueToolbar(sender: textField5B)
        SetKeyboardWithContinueToolbar(sender: textField1B)
        textField500L.delegate = self
        textField200L.delegate = self
        textField100L.delegate = self
        textField50L.delegate = self
        textField10L.delegate = self
        textField5L.delegate = self
        textField50B.delegate = self
        textField10B.delegate = self
        textField5B.delegate = self
        textField1L.delegate = self
        textField1B.delegate = self
       
        var m = MoneyModel(type: "500 LEI", value: 500.0, id: 0, textField: textField500L, pieces: 0, label: label500L)
        money.append(m!)
        m = MoneyModel(type: "200 LEI", value: 200.0, id: 1, textField: textField200L, pieces: 0, label: label200L)
        money.append(m!)
        m = MoneyModel(type: "100 LEI", value: 100.0, id: 2, textField: textField100L, pieces: 0, label: label100L)
        money.append(m!)
        m = MoneyModel(type: "50 LEI", value: 50.0, id: 3, textField: textField50L, pieces: 0, label: label50L)
        money.append(m!)
        m = MoneyModel(type: "10 LEI", value: 10.0, id: 4, textField: textField10L, pieces: 0, label: label10L)
        money.append(m!)
        m = MoneyModel(type: "5LEI", value: 5.0, id: 5, textField: textField5L, pieces: 0, label: label5L)
        money.append(m!)
        m = MoneyModel(type: "1 LEU", value: 1.0, id: 6, textField: textField1L, pieces: 0, label: label1L)
        money.append(m!)
        m = MoneyModel(type: "50 BANI", value: 0.5, id: 7, textField: textField50B, pieces: 0, label: label50B)
        money.append(m!)
        m = MoneyModel(type: "10 BANI", value: 0.1, id: 8, textField: textField10B, pieces: 0, label: label10B)
        money.append(m!)
        m = MoneyModel(type: "5 BANI", value: 0.05, id: 9, textField: textField5B, pieces: 0, label: label5B)
        money.append(m!)
        m = MoneyModel(type: "1 BAN", value: 0.01, id: 10, textField: textField1B, pieces: 0, label: label1B)
        money.append(m!)
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        for i in 0...money.count-1 {
            if textField == money[i].textField {
                if(textField.text != nil && textField.text != ""){
                    money[i].pieces = Int(textField.text!)!
                }
                money[i].textField.text = String(money[i].pieces)
            }
        }
        setTotal()
    }
    
    func SetKeyboardWithContinueToolbar(sender:UITextField) {
        let doneToolbar:UIToolbar = UIToolbar()
        //currentTextField = field
        let barButtonCancel = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action:  #selector(cancelButtonTapped(sender:)))
        barButtonCancel.tag = sender.tag
        let barButtonContinue = UIBarButtonItem(title: "Continue", style: UIBarButtonItem.Style.plain, target: self, action: #selector(continueButtonTapped(sender:)))
        barButtonContinue.tag = sender.tag
        doneToolbar.items=[
            barButtonCancel,
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            barButtonContinue
                ]
                
        doneToolbar.sizeToFit()
        sender.inputAccessoryView = doneToolbar
    }
    
    @objc
    func cancelButtonTapped(sender: UIBarButtonItem) {
        for i in 0...money.count-1 {
            if money[i].id == sender.tag {
                money[i].textField.resignFirstResponder()
                break
            }
        }

    }
    
    @objc func continueButtonTapped(sender: UIBarButtonItem) {
        let nextTag = sender.tag + 1

        for i in 0...money.count-1 {
            if money[i].id == nextTag {
                money[i].textField.becomeFirstResponder()
                let stackHeight = self.stackViewsMonetar.layer.bounds.height
                UIView.animate(withDuration: 0.3, animations: {
                    self.scrollView.contentOffset = CGPoint(x: 0, y: CGFloat(sender.tag) * stackHeight / CGFloat(self.money.count))
                })
                break
            } else {
                money[i].textField.resignFirstResponder()
            }
        }
    }
    
    func loadData(){
        let param = [Constants.ID_KEY: documentId] as [String: Int?]
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_MONETAR, parameters: param as Parameters)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    self.money[0].pieces = swiftyJsonVar[0][Constants.JSON_LEI_500].intValue
                    self.money[0].textField.text = String(self.money[0].pieces)
                    self.money[1].pieces = swiftyJsonVar[0][Constants.JSON_LEI_200].intValue
                    self.money[1].textField.text = String(self.money[1].pieces)
                    self.money[2].pieces = swiftyJsonVar[0][Constants.JSON_LEI_100].intValue
                    self.money[2].textField.text = String(self.money[2].pieces)
                    self.money[3].pieces = swiftyJsonVar[0][Constants.JSON_LEI_50].intValue
                    self.money[3].textField.text = String(self.money[3].pieces)
                    self.money[4].pieces = swiftyJsonVar[0][Constants.JSON_LEI_10].intValue
                    self.money[4].textField.text = String(self.money[4].pieces)
                    self.money[5].pieces = swiftyJsonVar[0][Constants.JSON_LEI_5].intValue
                    self.money[5].textField.text = String(self.money[5].pieces)
                    self.money[6].pieces = swiftyJsonVar[0][Constants.JSON_LEI_1].intValue
                    self.money[6].textField.text = String(self.money[6].pieces)
                    self.money[7].pieces = swiftyJsonVar[0][Constants.JSON_BANI_50].intValue
                    self.money[7].textField.text = String(self.money[7].pieces)
                    self.money[8].pieces = swiftyJsonVar[0][Constants.JSON_BANI_10].intValue
                    self.money[8].textField.text = String(self.money[8].pieces)
                    self.money[9].pieces = swiftyJsonVar[0][Constants.JSON_BANI_5].intValue
                    self.money[9].textField.text = String(self.money[9].pieces)
                    self.money[10].pieces = swiftyJsonVar[0][Constants.JSON_BANI_1].intValue
                    self.money[10].textField.text = String(self.money[10].pieces)
                    self.setTotal()
                }
        }
    }
    
    func setTotal() {
        var partial: Double = 0.0
        var total: Double = 0.0
       //let money = [500.0, 200.0, 100.0, 50.0, 10.0, 5.0, 1.0, 0.5, 0.1, 0.05, 0.01]
        for i in 0...money.count-1 {
            partial = money[i].value * Double(money[i].pieces)
            money[i].label.text = String(partial) + " LEI"
            total += partial
        }
        self.labelTotal.text = "Total: " + String(total) + " lei"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
