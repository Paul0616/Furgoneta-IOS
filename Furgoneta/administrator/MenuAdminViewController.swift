//
//  MenuAdminViewController.swift
//  Furgoneta
//
//  Created by Paul Oprea on 09/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MenuAdminViewController: UIViewController {

    @IBOutlet weak var locationsButton: UIButton!
    @IBOutlet weak var productsButton: UIButton!
    @IBOutlet weak var usersButton: UIButton!
    @IBOutlet weak var documentsButton: UIButton!
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        
        // Do ay additional setup after loading the view.
    
    }
    override func viewWillAppear(_ animated: Bool) {
        let backgroundImage = UIImage(named: "app_background")
        self.view.backgroundColor = UIColor(patternImage: backgroundImage!)
        locationsButton.layer.cornerRadius = 20
        productsButton.layer.cornerRadius = 20
        usersButton.layer.cornerRadius = 20
        documentsButton.layer.cornerRadius = 20
        locationsButton.titleLabel?.textAlignment = NSTextAlignment.center
        productsButton.titleLabel?.textAlignment = NSTextAlignment.center
        usersButton.titleLabel?.textAlignment = NSTextAlignment.center
        documentsButton.titleLabel?.textAlignment = NSTextAlignment.center
        activityIndicator.startAnimating()
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_LOCATIONS_NUM)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    let resultLoactions = swiftyJsonVar[0][Constants.RESULT_KEY].intValue
                    let resultProducts = swiftyJsonVar[1][Constants.RESULT_KEY].intValue
                    if resultLoactions == 0 {
                        self.locationsButton.isEnabled = false
                    }
                    else {
                        self.locationsButton.isEnabled = true
                    }
                    if resultProducts == 0 {
                        self.productsButton.isEnabled = false
                    }
                    else {
                        self.productsButton.isEnabled = true
                    }
                    self.activityIndicator.stopAnimating()
                }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backTapped(_ sender: UIBarButtonItem) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
            print("done")
        }
    }
   
    // MARK: - Navigation
@IBAction func unwindToMain(sender: UIStoryboardSegue){
    }
   /*  // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
