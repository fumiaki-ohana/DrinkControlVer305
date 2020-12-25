//
//  Tutorial4ViewController.swift
//  lastDrink
//
//  Created by 鶴見文明 on 2018/06/01.
//  Copyright © 2018年 Fumiaki Tsurumi. All rights reserved.
//

import UIKit

class Tutorial4ViewController: UIViewController {

    
   @IBAction func start(_ sender: UIButton) {
        flagReadMe = true
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
