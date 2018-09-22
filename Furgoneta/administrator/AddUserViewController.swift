//
//  AddUserViewController.swift
//  Furgoneta
//
//  Created by Paul Oprea on 10/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MessageUI

class AddUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MFMessageComposeViewControllerDelegate {
    
    
    


    @IBOutlet weak var roleDropButton: UIButton!
    @IBOutlet weak var dropListTableView: UITableView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scroller: UIScrollView!
    @IBOutlet weak var addLocationToUser: UIButton!
    @IBOutlet weak var lastNameTextField: DesignableUItextField!
    @IBOutlet weak var firstNameTextField: DesignableUItextField!
    @IBOutlet weak var phoneTextField: DesignableUItextField!

    @IBOutlet weak var emailTextField: DesignableUItextField!
    @IBOutlet weak var locationsNoLabel: UILabel!
    @IBOutlet weak var nickNameTextField: DesignableUItextField!
    @IBOutlet weak var saveUserButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    
    var index: Int?
    var firstName: String?
    var lastName: String?
    var roleId: Int?
    var phone: String?
    var email: String?
    var locationsNo: Int?
    var nickName: String?
    var password: String?
    var role: String?
    
    var roles = [RoleModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        dropListTableView.isHidden = true
        lastNameTextField.delegate = self
        firstNameTextField.delegate = self
        phoneTextField.delegate = self
        emailTextField.delegate = self
        nickNameTextField.delegate = self
        passwordTextField.delegate = self
       
        
        // Do any additional setup after loading the view.
        SetContinueToolbar(field: phoneTextField)
        if(self.index == nil || self.index == 0){
            self.title = "Adaugare user"
        }
    }

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            self.dismiss(animated: true, completion: nil)
            displayAlertMessages(userMessage: "Mesajul a fost oprit", toFocus: nil)
        case .failed:
            self.dismiss(animated: true, completion: nil)
            displayAlertMessages(userMessage: "Trimiterea mesajului a eșuat", toFocus: nil)
        case .sent:
            self.dismiss(animated: true, completion: nil)
            displayAlertMessages(userMessage: "SMS trimis", toFocus: nil)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backgroundImage = UIImage(named: "app_background")
        self.view.backgroundColor = UIColor(patternImage: backgroundImage!)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white;
        saveUserButton.layer.cornerRadius = 20
        addLocationToUser.layer.cornerRadius = 15
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.orange.cgColor
        let uuid = NSUUID().uuidString.lowercased()
        let pass = String(uuid.suffix(7))
        passwordTextField.text = pass
        loadingIndicator.startAnimating()
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_ROLES)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    for i in 0...(swiftyJsonVar.count-1){
                        let id = swiftyJsonVar[i][Constants.ID_KEY].intValue
                        let roleName = swiftyJsonVar[i][Constants.ROLE_KEY].stringValue
                        guard let role = RoleModel(id: id, roleName: roleName) else {
                            fatalError("Unable to instantiate ProductModel")
                        }
                        self.roles += [role]
                    }
                    self.firstNameTextField.text = self.firstName
                    self.lastNameTextField.text = self.lastName
                    self.phoneTextField.text = self.phone
                    self.emailTextField.text = self.email
                    self.nickNameTextField.text = self.nickName
                    if self.index != nil && self.index != 0 {
                        self.passwordTextField.text = self.password
                    }
                    if(self.role != nil && self.role != ""){
                        for roleItem in self.roles {
                            if roleItem.roleName == self.role {
                                self.roleId = roleItem.id
                            }
                        }
                        self.roleDropButton.setTitle(self.role, for: .normal)
                    }
                    self.dropListTableView.reloadData()
                    if self.index != nil && self.index != 0 {
                        let param = [Constants.ID_KEY: self.index] as! [String: Int]
                        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_USER_LOCATIONS, parameters: param)
                            .responseJSON{(responseData) -> Void in
                                if responseData.result.value != nil {
                                    let swiftyJsonVar = JSON(responseData.result.value!)
                                
                                    var suffix = " locații asociate userului"
                                    if (swiftyJsonVar.count == 1){
                                        suffix = " locație asociată userului"
                                    }
                                    self.locationsNoLabel.text = String(swiftyJsonVar.count) + suffix
                                   
                                }
                        }
                    }
                    self.loadingIndicator.stopAnimating()
                }
        }
    }
    @IBAction func onClickSendSMS(_ sender: Any) {
        if !validateInputs() {
            return
        }
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Datele contului tau FURGONETA:\nusername: " + nickNameTextField.text! +
                "\npassword: " + passwordTextField.text!;
            controller.recipients = [phoneTextField.text!]
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
   
    private func validateInputs() -> Bool {
        if !validateField(textField: lastNameTextField) {
            displayAlertMessages(userMessage: "Numele e obligatoriu", toFocus: lastNameTextField)
            return false
        }
        if !validateField(textField: firstNameTextField) {
            displayAlertMessages(userMessage: "Prenumele e obligatoriu", toFocus: firstNameTextField)
            return false
        }
        let phone = phoneTextField.text
        if !validatePhone(value: phone!) {
            displayAlertMessages(userMessage: "Numar de telefon mobil invalid", toFocus: phoneTextField)
            return false
        }
        let email = emailTextField.text
        if !validateEmail(email: email!) {
            displayAlertMessages(userMessage: "Email invalid", toFocus: emailTextField)
            return false
        }
        if !validateField(textField: nickNameTextField) {
            displayAlertMessages(userMessage: "Nickname e obligatoriu", toFocus: lastNameTextField)
            return false
        }
        if(roleId == nil || roleId == 0){
            resignAllFirtResponder()
            displayAlertMessages(userMessage: "Trebuie sa alegi un rol", toFocus: nil)
            return false
        }
        
        return true
    }
    @IBAction func onClickSaveUserButton(_ sender: UIButton) {
        if !validateInputs() {
            return
        }
        
        var param = [Constants.FIRST_NAME_KEY: firstNameTextField.text!, Constants.LAST_NAME_KEY: lastNameTextField.text!,
                     Constants.EMAIL_KEY: emailTextField.text!, Constants.PHONE_KEY: phoneTextField.text!,
                     Constants.ROLE_KEY: String(roleId!), Constants.USER_NAME_KEY: nickNameTextField.text!, Constants.USER_PASSWORD_KEY: passwordTextField.text!]
        
        if index != nil && index != 0 {
            param.merge([Constants.ID_KEY: String(index!)], uniquingKeysWith: { (current, _) in current })
        }
        loadingIndicator.startAnimating()
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_SET_USER, parameters: param)
        .responseJSON{(responseData) -> Void in
            if responseData.result.value != nil {
                self.loadingIndicator.stopAnimating()
                if((self.presentingViewController) != nil){
                    self.dismiss(animated: false, completion: nil)
                }
            }
        }

    }
    @IBAction func onClickTogglePassword(_ sender: UIButton) {
        resignAllFirtResponder()
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    @IBAction func onClickBack(_ sender: UIBarButtonItem) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
    @IBAction func onClickRoleDropButton(_ sender: Any) {
        resignAllFirtResponder()
       animate(toogle: dropListTableView.isHidden)
    }
    func animate(toogle: Bool){
        UIView.animate(withDuration: 0.3, animations: {
            self.dropListTableView.isHidden = !toogle
        })
    }
    
    private func validateEmail(email: String) -> Bool {
        let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let __emailRegex = __firstpart + "@" + __serverpart + "[A-Za-z]{2,8}"
        let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)
        return __emailPredicate.evaluate(with: email)
    }
    
    private func validateField(textField: UITextField) -> Bool {
        let trimmed = textField.text?.trimmingCharacters(in: .whitespaces)
        return !trimmed!.isEmpty
    }
    private func validatePhone(value: String) -> Bool {
        let trimmedString = value.trimmingCharacters(in: .whitespaces)
        let a = String(trimmedString.prefix(2))
        if (a == "07") && value.count == 10 {
            return true
        } else {
            return false
        }
//        let phoneNumberRegex = "\\0\\[27]\\[0-9]{8}$"
//        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
//        let isValidPhone = phoneTest.evaluate(with: self)
//        return isValidPhone
    }
    
    private func resignAllFirtResponder() {
        if lastNameTextField.isFirstResponder {
            lastNameTextField.resignFirstResponder()
        }
        if firstNameTextField.isFirstResponder {
            firstNameTextField.resignFirstResponder()
        }
        if phoneTextField.isFirstResponder {
            phoneTextField.resignFirstResponder()
        }
        if emailTextField.isFirstResponder {
            emailTextField.resignFirstResponder()
        }
        if nickNameTextField.isFirstResponder {
            nickNameTextField.resignFirstResponder()
        }
    }

    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case lastNameTextField:
                firstNameTextField.becomeFirstResponder()
            case firstNameTextField:
                firstNameTextField.resignFirstResponder()
            case phoneTextField:
                phoneTextField.resignFirstResponder()
                emailTextField.becomeFirstResponder()
            case phoneTextField:
                nickNameTextField.becomeFirstResponder()
            case emailTextField:
                UIView.animate(withDuration: 0.3, animations: {
                    self.scroller.contentOffset = CGPoint(x: 0, y: 300)
                })
                nickNameTextField.becomeFirstResponder()
            default:
                textField.resignFirstResponder()
        }
        return true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let assignLocation = segue.destination as? AssignLocationTableViewController, segue.identifier == "addLocationsToUser" {
            assignLocation.userId = index!
        }
    }
    
    
    //MARK: - present messages
    func displayAlertMessages(userMessage: String, toFocus:UITextField!){
        let myAlert = UIAlertController(title: "Atentie", message: userMessage, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {_ in
            if toFocus != nil {
                toFocus.becomeFirstResponder()
            }
        })
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
    // MARK: -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roles.count
    }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellRoles", for: indexPath)
        cell.textLabel?.text = roles[indexPath.row].roleName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        roleId = roles[indexPath.row].id
        roleDropButton.setTitle("\(roles[indexPath.row].roleName)", for: .normal)
        animate(toogle: false)
    }
    
    
    func SetContinueToolbar(field:DesignableUItextField) {
        let doneToolbar:UIToolbar = UIToolbar()
        
        doneToolbar.items=[
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(cancelButtonTapped)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Continue", style: UIBarButtonItem.Style.plain, target: self, action: #selector(continueButtonTapped))
        ]
        
        doneToolbar.sizeToFit()
        field.inputAccessoryView = doneToolbar
    }
    
    @objc func continueButtonTapped() { emailTextField.becomeFirstResponder() }
    @objc func cancelButtonTapped() { phoneTextField.resignFirstResponder() }
    
}

