//
//  LocationModalViewController.swift
//  Furgoneta
//
//  Created by Paul Oprea on 10/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit

class LocationModalViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var locationNameTextField: UITextField!
    var index: Int?
    var locationName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationNameTextField.delegate = self
        if(locationName != nil) {
            locationNameTextField.text = locationName
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
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide keyboard
        if textField == locationNameTextField{
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
