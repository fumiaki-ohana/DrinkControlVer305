//
//  WT02AViewController.swift
//  DrinkControl
//
//  Created by 鶴見文明 on 2020/10/23.
//  Copyright © 2020 OHANA Inc. All rights reserved.
//

import UIKit

class WT02AViewController: UIViewController {

    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        self.overrideUserInterfaceStyle = .light
        super.viewDidLoad()
        showAnimation(parentView:self.view, lottieJason: "3152-star-success",fullScreen:true)
        setButtonProperties(button: nextButton,rgbaStr:"#F99F48" )
        nextButton.setTitle( "アプリの使い方ツアーへ", for: .normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
