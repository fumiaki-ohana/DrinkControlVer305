//
//  DateEntryViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2018/11/07.
//  Copyright © 2018 Fumiaki Tsurumi. All rights reserved.
//

import UIKit

class DateEntryViewController: UIViewController {
    
    @IBOutlet weak var drinkDate: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBAction func dueDatePicker(_ sender: UIDatePicker) {
        drinkDate.text = sender.date.mediumStr
        entryDate = sender.date
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        entryDate = nil
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drinkDate.text =  Date().mediumStr
        datePicker.date = Date()
        entryDate = Date()
    
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
