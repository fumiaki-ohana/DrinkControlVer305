//
//  MasterViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2018/04/23.
//  Copyright © 2018年 Fumiaki Tsurumi. All rights reserved.
//

import UIKit
//import SwiftIconFont

class MasterViewController: UITableViewController {
    
    typealias cellArray = [cellTupple]
    typealias cellTupple = (title: String, desc: String, style:UITableViewCell.AccessoryType)
    var mySections = [String]()
    var twoDimArray = [cellArray]()
    let sectionTitleArray:[String] = ["飲んだお酒の量を入力",
                                      "計算結果（1ドリンク＝アルコール10グラム)"]
    var drinkDaily = DrinkDailyRecord(dDate: Date(), drinks:[Drink](), totalUnits: 0)
    
//    セグエでの値の受け渡し
    var drinkItem = Drink(dname: eDname.wine, damount: 0)
    
    // Mark: - Properties
//    var detailViewController: DetailViewController? = nil
    var results=[(String,Double)]()
    var diff:Double {
        return  (self.drinkDaily?.TU)! - targetUnit
    }
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if saveButton.isEnabled {
            showAlert(title: "データが変更されています",message: "続行しますか？") }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
        
   
    let viewPrompt = "純アルコール量（ドリンク数)を計算します。"
    
    // Mark: - Table elements
    
    let iconFontSize = CGFloat(25.0)
    
    // Mark: - Initialize
    override func viewDidLoad() {
        let userDefaults:UserDefaults = UserDefaults.standard
        userDefaults.register(defaults: ["readMe": false])
        
        super.viewDidLoad()
        mySections = sectionTitleArray
        twoDimArray = loadDataForTable(drink: self.drinkDaily!)
       
        self.navigationItem.title = drinkDaily?.dDate.mediumStr
        self.navigationItem.prompt = viewPrompt
        
        saveButton.isEnabled = false
//        cancelButton.isEnabled = false
    }
    
   
    
    private func loadDataForTable(drink:DrinkDailyRecord)  -> [cellArray] {
        
        //Section 1 for tableview

        var array_0 = cellArray()
        for item in drink.drinks {
            let record:cellTupple = (title:item.dname.ctitle (emoji: emojiSwitch),  desc:item.damount.decimalStr, style:.disclosureIndicator)
                array_0.append(record)
            }
    
        //Section 2 for tableview
        let cellText:[String] = ["純アルコール量の合計","上限目標","差"]
        
        let item0:cellTupple = (title:cellText[0], desc:(self.drinkDaily!.TU.decimalStr),style:.none)
        
        let item1:cellTupple = (title:cellText[1], desc:targetUnit.decimalStr,style:.none)
        
        let diff = self.drinkDaily!.TU - targetUnit
        let item2:cellTupple = (title:cellText[2], desc:diff.decimalStr,style:.none)
        
        let array_1 = [item0,item1,item2]
       
        return [array_0,array_1]
        }
    
    
    //MARK: Private Methods
    
    override func viewWillAppear(_ animated: Bool) {
        
        guard flagReadMe else {
            loadTutor()
            return
        }
        self.tableView.reloadData()
        super.viewWillAppear(animated)
    }
    
    //Mark: 立ち上げのときに1回だけ、Tutor画面を表示する。
    
    private func loadTutor() {
    
    let storyboard: UIStoryboard = UIStoryboard(name: "TutorialStoryboard", bundle: nil)
    let nextView = storyboard.instantiateInitialViewController() as! Tutorial4ViewController
        self.present(nextView, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return mySections.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return twoDimArray[section].count
        }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mySections[section]
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = twoDimArray[indexPath.section][indexPath.row].title
        cell.detailTextLabel?.text = twoDimArray[indexPath.section][indexPath.row].desc
        cell.accessoryType = twoDimArray[indexPath.section][indexPath.row].style
        cell.selectionStyle = (indexPath.section == 1) ? .none : .default
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }

/*
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if indexPath.section < 2 {
            return indexPath }
        else {
            if indexPath.row == 1 {
                return indexPath
            }
        }
            return nil }
 */
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showDetail":
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = drinkDaily!.drinks[indexPath.row]
                let controller = segue.destination as! DataEntryTableViewController
                controller.drink = object
                controller.dDate = drinkDaily!.dDate
            }
        default: break
        }
    }
  
    @IBAction func unwindToMasterView(sender: UIStoryboardSegue) {
        saveButton.isEnabled = true

        if let sourceViewController = sender.source as? DataEntryTableViewController,
            let changed_drink = sourceViewController.drink {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                drinkDaily!.drinks[selectedIndexPath.row] = changed_drink
                
                twoDimArray = loadDataForTable(drink:drinkDaily!)
                tableView.reloadData()
            }
    }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
//        case 0: performSegue(withIdentifier: "showDetail", sender: self)
       case 0: performSegue(withIdentifier: "showDetail", sender: self)
       default: break
        }
        
    }
    
    func showAlert(title: String?, message: String?)  {
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .actionSheet)
        
        let okAction = UIAlertAction(title: "続行",
                                     style: .default) { action in
                                        self.navigationController?.popViewController(animated: true)}
        
        let cancelAction = UIAlertAction(title: "取り止め",
                                         style: .cancel,
                                         handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}



