//
//  ViewController.swift
//  Furgoneta
//
//  Created by Paul Oprea on 07/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class MainViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var myLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var underlineUsername: UIView!
    @IBOutlet weak var underlinePassword: UIView!
    
    //MARK: - UIViewControlle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.username.delegate = self
        self.password.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backgroundImage = UIImage(named: "app_background")
        self.view.backgroundColor = UIColor(patternImage: backgroundImage!)
        startButton.layer.cornerRadius = 20
        logoutButton.layer.cornerRadius = 20
        if let userId = UserDefaults.standard.object(forKey: Constants.USER_ID_KEY){
            let parameters = [Constants.USER_ID_KEY: userId]
            myLoadingIndicator.startAnimating()
            Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_USER_STATUS, parameters: parameters)
                .responseJSON{(responseData) -> Void in
                    if((responseData.result.value) != nil){
                        self.myLoadingIndicator.stopAnimating()
                        let swiftyJsonVar = JSON(responseData.result.value!)
                        let result = swiftyJsonVar[0][Constants.RESULT_KEY].intValue
                        if result == 1 {
                            let status = swiftyJsonVar[1][Constants.STATUS_KEY].intValue
                            if status == 0 {
                                let first = UserDefaults.standard.object(forKey: Constants.FIRST_NAME_KEY) as! String
                                let last = UserDefaults.standard.object(forKey: Constants.LAST_NAME_KEY) as! String
                                self.displayAlertMessages(userMessage: "Userul " + first + " " + last + " temporar inactiv", toFocus: self.username)
                                UserDefaults.standard.setValuesForKeys([Constants.EMAIL_KEY:"",
                                                              Constants.USER_ID_KEY:0,
                                                              Constants.ROLE_KEY:"",
                                                              Constants.FIRST_NAME_KEY: "",
                                                              Constants.LAST_NAME_KEY:""])
                                self.setLogOut()
                            } else {
                                self.setLogIn()
                            }
                        }
                    }
            }
        }
    }
    
    //MARK: -
    @IBAction func logInStartTapped(_ sender: Any) {
        let preferences = UserDefaults.standard
    
        if preferences.object(forKey: Constants.USER_ID_KEY) == nil || preferences.object(forKey: Constants.USER_ID_KEY) as! Int == 0 {
            username.resignFirstResponder()
            password.resignFirstResponder()
            attemptLogin()
        } else {
            if preferences.object(forKey: Constants.ROLE_KEY) != nil{
                let role = preferences.string(forKey: Constants.ROLE_KEY)
                switch role {
                case "administrator":
                        self.performSegue(withIdentifier: "menu_admin", sender: self)
                case "manager":
                        print("manager")
                case "sofer":
                        print("sofer")
                case .none:
                    print("none")
                case .some(_):
                    print("some")
                }
            
            }
        }
        
    }
    
    @IBAction func logOutTapped(_ sender: Any) {
        password.text = ""
        username.text = ""
        UserDefaults.standard.setValuesForKeys([Constants.EMAIL_KEY:"",
                                      Constants.USER_ID_KEY:0,
                                      Constants.ROLE_KEY:"",
                                      Constants.FIRST_NAME_KEY: "",
                                      Constants.LAST_NAME_KEY:""])
        self.setLogOut()
    }
    

    //MARK: - UItextfieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        if textField == username{
            password.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            attemptLogin()
        }
        return true
    }
    //MARK: - private
    func attemptLogin(){
        let userNameText = username.text
        let passwordText = password.text
        if(userNameText?.isEmpty)!{
            displayAlertMessages(userMessage: "User name e obligatoriu", toFocus: self.username)
            return
        }
        if(passwordText?.isEmpty)!{
            displayAlertMessages(userMessage: "Parola e obligatorie", toFocus: self.password)
            return
        }
        if((passwordText?.count)! < 5){
            displayAlertMessages(userMessage: "Parola e prea scurta", toFocus: self.password)
            return
        }
        let parameters: Dictionary<String, String> = [Constants.USER_NAME_KEY :userNameText! , Constants.USER_PASSWORD_KEY: passwordText!]
        myLoadingIndicator.startAnimating()
        loadData(parameters: parameters)
    }
    
    func loadData(parameters: Dictionary<String, String>){
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_LOGIN, parameters: parameters)
            .responseJSON{(responseData) -> Void in
                if((responseData.result.value) != nil){
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    let id = swiftyJsonVar[0][Constants.RESULT_KEY].intValue
                    switch id {
                    case 1:
                        let email = swiftyJsonVar[3][Constants.EMAIL_KEY].stringValue
                        let userId = swiftyJsonVar[1][Constants.USER_ID_KEY].intValue
                        let role = swiftyJsonVar[2][Constants.ROLE_KEY].stringValue
                        let first = swiftyJsonVar[5][Constants.LAST_NAME_KEY].stringValue
                        let last = swiftyJsonVar[4][Constants.FIRST_NAME_KEY].stringValue
                        let preferences = UserDefaults.standard
                        preferences.setValuesForKeys([Constants.EMAIL_KEY:email,
                                                               Constants.USER_ID_KEY:userId,
                                                               Constants.ROLE_KEY: role,
                                                               Constants.FIRST_NAME_KEY: first,
                                                               Constants.LAST_NAME_KEY:last])
                        self.setLogIn()
                    case 2:
                        self.displayAlertMessages(userMessage: "Acest username nu exista", toFocus: self.username)
                    case 3:
                        self.displayAlertMessages(userMessage: "Parola incorecta", toFocus: self.password)
                    case 4:
                        self.username.text = ""
                        self.password.text = ""
                        self.displayAlertMessages(userMessage: "Acest username e temporar inactiv", toFocus: self.username)
                    
                    default:
                        print("Id not found")
                    }
                }
                self.myLoadingIndicator.stopAnimating()
            }
    }
    
    func setLogIn(){
        username.isHidden = true
        underlineUsername.isHidden = true
        password.isHidden = true
        underlinePassword.isHidden = true
        startButton.setTitle("START", for: UIControl.State.normal)
        logoutButton.isHidden = false
    }
    
    func setLogOut(){
        username.isHidden = false
        underlineUsername.isHidden = false
        password.isHidden = false
        underlinePassword.isHidden = false
        startButton.setTitle("Autentificare", for: UIControl.State.normal)
        logoutButton.isHidden = true
    }
    
    //MARK: - present messages
    func displayAlertMessages(userMessage: String, toFocus:UITextField){
        let myAlert = UIAlertController(title: "Atentie", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
            toFocus.becomeFirstResponder()
        })
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
//        switch (segue.identifier ?? "") {
//        case "menu_admin":
//            guard let menuAdminDestination = segue.destination as? UINavigationController
//                else{
//                    fatalError("Unexpected destination: \(segue.destination)")
//            }
//           
//
//        
//        default:
//            fatalError("Unexpeted segue Identifier; \(String(describing: segue.identifier))")
//        }
     }
    
}

