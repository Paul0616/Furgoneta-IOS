//
//  AddUsersTableViewController.swift
//  Furgoneta
//
//  Created by Paul Oprea on 10/09/2018.
//  Copyright © 2018 Paul Oprea. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class AddUsersTableViewController: UITableViewController {

    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var users = [UserModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 135
        tableView.allowsSelection = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    override func viewWillAppear(_ animated: Bool) {
        loadData()
    }
    @IBAction func deleteButtonAction(_ sender: UIButton) {
        let id = users[sender.tag].id
        let param = [Constants.ID_KEY: id]
       //activityIndicator.startAnimating()
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_DELETE_USER, parameters: param)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                    self.loadData()
                  //  self.activityIndicator.stopAnimating()
                }
        }
    }
    @IBAction func onClickBackButton(_ sender: Any) {
        if((self.presentingViewController) != nil){
            self.dismiss(animated: false, completion: nil)
        }
    }
    @IBAction func statusSwichValueChange(_ sender: UISwitch) {
        let value = sender.isOn ? 1 : 0
        let id = users[sender.tag].id
        let param = [Constants.STATUS_KEY: value, Constants.ID_KEY: id]
       //activityIndicator.startAnimating()
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_SET_USER_STATUS, parameters: param)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                    self.users[sender.tag].status = sender.isOn
                    self.tableView.reloadData()
                 //   self.activityIndicator.stopAnimating()
                }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    func loadData(){
        users.removeAll()
  //     activityIndicator.startAnimating()
        Alamofire.request(Constants.BASE_URL_STRING+"/"+Constants.FILE_GET_ALL_USERS)
            .responseJSON{(responseData) -> Void in
                if responseData.result.value != nil {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    for i in 0...(swiftyJsonVar.count-1){
                        let id = swiftyJsonVar[i][Constants.ID_KEY].intValue
                        let status = swiftyJsonVar[i][Constants.STATUS_KEY].intValue == 1 ? true : false
                        let userFirstName = swiftyJsonVar[i][Constants.FIRST_NAME_KEY].stringValue
                        let userLastName = swiftyJsonVar[i][Constants.LAST_NAME_KEY].stringValue
                        let role = swiftyJsonVar[i][Constants.ROLE_KEY].stringValue
                        let nickName = swiftyJsonVar[i][Constants.USER_NAME_KEY].stringValue
                        let password = swiftyJsonVar[i][Constants.USER_PASSWORD_KEY].stringValue
                        let phone = swiftyJsonVar[i][Constants.PHONE_KEY].stringValue
                        let email = swiftyJsonVar[i][Constants.EMAIL_KEY].stringValue
                        guard let user = UserModel(id: id, status: status, userFirstName: userFirstName, userLastName: userLastName, role: role, nickName: nickName, password: password, phone: phone, email: email) else {
                            fatalError("Unable to instantiate ProductModel")
                        }
                        self.users += [user]
                    }
                    self.tableView.reloadData()
                   // self.activityIndicator.stopAnimating()
                }
        }
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserTableViewCell
        
        cell.userNameLabel.text = users[indexPath.row].userFirstName + " " + users[indexPath.row].userLastName
        cell.statusSwitch.isOn = users[indexPath.row].status
        cell.statusSwitch.tag = indexPath.row
        if !users[indexPath.row].status {
            cell.userNameLabel.textColor = UIColor.orange
        } else {
            cell.userNameLabel.textColor = UIColor.black
        }
        
        cell.roleLabel.text = users[indexPath.row].role
        cell.editBtn.tag = indexPath.row
        cell.delBtn.tag = indexPath.row

        // Configure the cell...

        return cell
    }
  

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        switch (segue.identifier ?? "") {
            
        case "editUser":
            guard let selectedEditBtn = sender as? UIButton else{
                fatalError("Unexpeted sender: \(String(describing: sender))")
            }
            if let nav = segue.destination as? UINavigationController, segue.identifier == "editUser" {
                if let addUserViewController = nav.visibleViewController as? AddUserViewController {
                    addUserViewController.index = users[selectedEditBtn.tag].id
                    addUserViewController.firstName = users[selectedEditBtn.tag].userFirstName
                    addUserViewController.lastName = users[selectedEditBtn.tag].userLastName
                    addUserViewController.role = users[selectedEditBtn.tag].role
                    addUserViewController.phone = users[selectedEditBtn.tag].phone
                    addUserViewController.email = users[selectedEditBtn.tag].email
                    addUserViewController.nickName = users[selectedEditBtn.tag].nickName
                    addUserViewController.password = users[selectedEditBtn.tag].password
                }
            }
        case "addUser":
            print("add user")
        default:
            fatalError("Unexpeted segue Identifier; \(String(describing: segue.identifier))")
        }
    }
   

}
