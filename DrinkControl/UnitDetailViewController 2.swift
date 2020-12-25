//
//  DetailViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2018/04/23.
//  Copyright © 2018年 Fumiaki Tsurumi. All rights reserved.
//

import UIKit
import os.log
//import SwiftIconFont

class UnitDetailViewController: UIViewController {
    
    var drinkUD = Drink(dname: eDname.wine, damount: 0)
    var name: String = ""
    var damount: Int = 0
    var dunitAl: Double = 1.0
    var stepperNewValue: Double = 1.0
   
    
    @IBOutlet weak var drinkName: UILabel!
    @IBOutlet weak var amount: UILabel! //alc.
   
    @IBOutlet weak var unitAmount: UILabel!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var remarksLabel: UILabel!
    
    
    @IBOutlet weak var stepper: UIStepper!
/*
    @IBAction func Tap(_ sender: UITapGestureRecognizer) {
        restoreDefault()
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
         dismiss(animated: true, completion: nil)
    }
  */
    func restoreDefault() {
        
        let alertController = UIAlertController(
            title:(drinkUD?.dname.rawValue)!+"で設定できる範囲を超えています。",
            message: "標準値\(String(describing: dPUnit[(drinkUD?.dname)!]!.percentStr))の上下50%以内にしてください。",
            preferredStyle: .actionSheet)
     
        alertController.addAction (
            UIAlertAction (title: "変更を取り消します。", style: .default, handler:{
                (action: UIAlertAction!) in
                self.restoreDefaultUnit()
            })
        )
            present(alertController,animated:true, completion: nil)
        }
   
  
    func restoreDefaultUnit() {
       
        drinkUD = Drink(dname:(drinkUD?.dname)!, damount:(drinkUD?.damount)!)
        amount.text = dunitAl.percentStr
        unitAmount.text = drinkUD?.unitAm.decimalStr
        stepper.value = Double(dunitAl)
    }

    override func viewDidLoad() {
    
        func configureView() {
           
            // Update the user interface for the detail item.
            damount = (drinkUD?.damount)!
            dunitAl = (drinkUD?.unitAl)!
            
            drinkName.text = drinkUD?.dname.rawValue
            amount.text = dunitAl.percentStr
            unitAmount.text = drinkUD?.unitAm.decimalStr
            
            remarksLabel.text = "注意："+(drinkUD?.dname.rawValue)!+"の標準アルコール濃度"+dPUnit[(drinkUD?.dname)!]!.percentStr+"に対し上下50%の範囲を超えた設定はできません。"
        }
        func showUIStepper(){
            //最小値を設定
           // stepper.minimumValue = dPUnit[(drinkUD?.dname)!]! * 0.5
            //最大値を設定
           // stepper.maximumValue = dPUnit[(drinkUD?.dname)!]! * 1.5
            //初期値を設定
            stepper.value = Double(dunitAl)
            //stepperが押された時の変化値を設定
            stepper.stepValue = 0.1
            //stepperが押された時の処理を設定
            stepper.addTarget(self,
                              action: #selector(onChange),
                              for: .valueChanged)
        }
        super.viewDidLoad()
        configureView()
        showUIStepper()
        
    }
    //stepperが押された時の処理
    @objc func onChange(sender:UIStepper){
        let lower =  dPUnit[(drinkUD?.dname)!]! * 0.5
        let upper =  dPUnit[(drinkUD?.dname)!]! * 1.5
        let closedRange = lower...upper
        
        stepperNewValue = sender.value
        
        if !closedRange.contains(stepperNewValue) {
            restoreDefault()
        } else {
        let name = drinkUD?.dname
        drinkUD = Drink(dname: name!, damount: damount)
            eDname.alc_dic[name!] = stepperNewValue
        amount.text = stepperNewValue.percentStr
        unitAmount.text = drinkUD?.unitAm.decimalStr
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
     
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
    }
    
    }

