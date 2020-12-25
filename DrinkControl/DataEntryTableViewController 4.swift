//
//  DataEntryTableViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2019/08/27.
//  Copyright © 2019 Fumiaki Tsurumi. All rights reserved.
//

import UIKit

class DataEntryTableViewController: UITableViewController {
    var dDate = Date()
    var drink = Drink(dname: eDname.wine, damount: 0)
    var mySections = [String]()
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBAction func stepperChange(_ sender: UIStepper) {
        drink?.damount = Int(sender.value)
        amountLabel.text = String(sender.value)
        drinkEmoji.text = drink!.emojiStr
        altMeasure.text = drink!.altMeasured
        drinkNum.text = drink!.numOfDrinkUnit.decimalStr
        save.isEnabled = true
    }
    @IBOutlet weak var drinkNum: UILabel!
    @IBOutlet weak var drinkEmoji: UILabel!
    
    @IBOutlet weak var altMeasure: UILabel!
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
    }
    
    @IBOutlet weak var save: UIBarButtonItem!
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        if save.isEnabled {
            showAlert(title: "データが変更されています",message: "続行しますか？") }
        else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        showUIStepper()
    }
    
    // MARK: - Table view data source
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return mySections.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mySections[section]
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if  indexPath.section == 3 {
            switch indexPath.row {
            case 0: cell.textLabel!.text = "アルコール濃度"
            cell.detailTextLabel!.text = eDname.alc_dic[drink!.dname]?.percentStr
            case 1: cell.textLabel!.text = "１ドリンク相当の飲酒量"
            cell.detailTextLabel!.text = drink!.dname.unitAm.decimalStr
                
            default: break
                
            }
        }
        return cell
    }
    
    func showUIStepper(){
        //最小値を設定
        stepper.minimumValue = 0
        //最大値を設定
        stepper.maximumValue = 2500
        //初期値を設定
        stepper.value = Double(drink!.damount)
        //stepperが押された時の変化値を設定
        stepper.stepValue = 50
        
        amountLabel.text = drink!.damount.decimalStr
        altMeasure.text = drink!.altMeasured
        drinkEmoji.text = drink!.emojiStr
        drinkNum.text = drink!.numOfDrinkUnit.decimalStr
        navigationItem.title = ((drink?.dname.ctitle (emoji: emojiSwitch))!)
        
        save.isEnabled = false
        
        mySections = [dDate.mediumStr,"ドリンク数"," ", "現在の設定値"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        drink = Drink (dname: (drink?.dname)!, damount: drink!.damount)
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
