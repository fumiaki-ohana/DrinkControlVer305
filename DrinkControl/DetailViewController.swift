//
//  DetailViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2018/04/23.
//  Copyright © 2018年 Fumiaki Tsurumi. All rights reserved.
//

import UIKit
import os.log

class DetailViewController: UIViewController {

    @IBOutlet weak var drinkLabel: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var saveButton: UIBarButtonItem!
  //  @IBOutlet weak var indictiveDrink: UILabel!
  //  @IBOutlet weak var indictiveDrink: UITextView!
    //@IBOutlet weak var indictiveDrink: UITextView!
    @IBOutlet weak var indictiveDrink: UITextView!
    
    var drink = Drink(dname: eDname.wine, damount: 0)
    var num = Int()
    var al = Double()
    
    override func viewDidLoad() {
        
        func configureView() {
        // Update the user interface for the detail item.
            if let detailItem = drink {
                drinkLabel.text = detailItem.dname.rawValue
                num = detailItem.damount
                al = detailItem.unitAl
                amount.text = num.decimalStr
            
                indictiveDrink.text = "おおよその目安としては、"+Drink.dPIndictive[(detailItem.dname)]!+"が"+Drink.dPIndictiveAmount[(detailItem.dname)]!+"です。"

            }
        }
        
        func showUIStepper(){
            //最小値を設定
            stepper.minimumValue = 0
            //最大値を設定
            stepper.maximumValue = 2500
            //初期値を設定
            stepper.value = Double(num)
            //stepperが押された時の変化値を設定
            stepper.stepValue = 50
            //stepperが押された時の処理を設定
            stepper.addTarget(self,
                              action: #selector(onChange),
                              for: .valueChanged)
            //viewにstepperをsubviewとして追加
            self.view.addSubview(stepper)
        }
        
        super.viewDidLoad()
        configureView()
        showUIStepper()
    }
    //stepperが押された時の処理
    @objc func onChange(sender:UIStepper){
        num = Int(sender.value)
        amount.text = num.decimalStr
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        /*
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        */
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        drink = Drink (dname: (drink?.dname)!, damount: num)
    }
    
    }

