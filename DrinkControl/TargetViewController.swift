//
//  TargetViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2018/05/16.
//  Copyright © 2018年 Fumiaki Tsurumi. All rights reserved.
//

import UIKit
import os.log

class TargetViewController: UIViewController {
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var tv: UITextView!
    
    var targetTV:Double = 0.0
    var interimTV:Double = 0.0
    let descriptionText = "厚生労働省によると、節度ある適度な飲酒は、1日平均純アルコールで20グラム程度の飲酒(=2ドリンク)とされますが、個人差があります。ご自身の適量を設定ください。"

    override func viewDidLoad() {
        
        func configureView() {
            // Update the user interface for the detail item.
                targetLabel.text = targetTV.decimalStr
          //      descriptionLabel.text = descriptionText
                tv.text = descriptionText
        }
        
        func showUIStepper(){
            //最小値を設定
            stepper.minimumValue = 0
            //最大値を設定
            stepper.maximumValue = 5
            //初期値を設定
            stepper.value = targetTV
            //stepperが押された時の変化値を設定
            stepper.stepValue = 0.2
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
        interimTV = sender.value
        targetLabel.text = interimTV.decimalStr
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
        targetTV = interimTV
        // Set the meal to be passed to MealTableViewController after the unwind segue.
        
    }
    
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

